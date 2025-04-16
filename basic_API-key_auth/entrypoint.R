# Sajna ez az egesz szarsag nem mukodik.

add_auth <- function(
		api,
		paths = NULL
) {
	
	api[["components"]] <- list(
		securitySchemes = list(
			ApiKeyAuth = list(
				type = "apiKey",
				`in` = "header",
				name = "API_KEY",
				description = "Add API Key here"
			)
		)
	)
	
	# Ez a resz itt azt biztositja, hogy az OSSZES endpointra egyszerre megkapjuk a jogositast (vagy egyikre sem...)
	if (is.null(paths)) paths <- names(api$paths)
	for (path in paths) {
		nn <- names(api$paths[[path]])
		for (p in intersect(nn, c("get", "head", "post", "put", "delete"))) {
			api$paths[[path]][[p]] <- c(
				api$paths[[path]][[p]],
				list(security = list(list(ApiKeyAuth = vector())))
			)
		}
	}
	
	api
	
}

pr("basic_API-key_auth/plumber_API_key.R") |> #nolint
	pr_set_api_spec(add_auth) |>
	pr_hook("preroute", function(req, res) {
		res$setHeader("Access-Control-Allow-Origin", "http://localhost:8008")
		res$setHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		res$setHeader("Access-Control-Allow-Headers", "MY_API_KEY, Accept")
		res$setHeader("Access-Control-Allow-Credentials", "true")
		if (req$REQUEST_METHOD == "OPTIONS") {
			res$status <- 200
			return(list())
		}
		plumber::forward()
	}) |>
	pr_run(
		port = 8008,
		host = "0.0.0.0"
	)