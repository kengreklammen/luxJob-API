library(RPostgres)
library(DBI)
library(glue)
library(luxJob)

#source("connect_db.R")

verify_token <- function(token = NULL, schema = 'student_arpad') {
	if(is.null(token) || is.numeric(token)){return(FALSE)}
	con <- connect_db()
	sql <- glue::glue_sql("select token from api_users where token like {token};", .con = con)
	DBI::dbExecute(con, paste0("SET search_path TO ", schema))
	df <- DBI::dbGetQuery(con, sql)
	DBI::dbDisconnect(con)
	if((nrow(df) == 0) || (df$token != token)){return(FALSE)}
	return(TRUE)
}