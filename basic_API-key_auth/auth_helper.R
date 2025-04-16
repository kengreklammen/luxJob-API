# Sajna ez az egesz szarsag nem mukodik.

auth_helper <- function(
		res,
		req,
		FUN,
		...
) {
	req_has_key <- "MY_API_KEY" %in% names(req)
	key_is_valid <- req$MY_API_KEY == Sys.getenv("API_KEY")
	environment_not_set <- nchar(Sys.getenv("API_KEY")) <= 1
	if (!req_has_key || !key_is_valid || environment_not_set) {
		res$body <- "Unauthorized"
		res$status <- 401
		"Missing or invalid API key, or invalid configuration!"
	} else {
		FUN(...)
	}
}