# This is a working example of the luxJob API with a Bearer Token authorization, where
#  the tokens are stored in a PostgreSQL database

library(plumber)
# plumber.R

source("verify_token.R")

auth_helper <- function(res, req, FUN, ..., render_as_widget = FALSE) {
	# Get token from header: "Authorizat
	# ion: Bearer mytoken123"
	auth_header <- if (!is.null(req$HTTP_AUTHORIZATION)) req$HTTP_AUTHORIZATION else ""
	token <- sub("^Bearer ", "", auth_header)
	valid_token <- Sys.getenv("BEARER_TOKEN")
	
	#if (nchar(valid_token) <= 1 || token != valid_token) {
	if (!verify_token(token, 'student_arpad')) {
		
		res$status <- 401
		
		if (render_as_widget) {
			return(
				plotly::plotly_empty(type = "scatter") %>%
					layout(title = "Unauthorized: Invalid or missing token")
			)
		}
		
		return(list(error = "Unauthorized: Invalid or missing token"))
	}
	
	FUN(...)
}


#* @apiTitle LuxJob API
#* @apiDescription This is an API to retrieve vacancy-related data from the ADEM database.
#* @apiVersion 1.0.0
#* @apiLicense MIT


#* Get all skills.
#* @param limit:number The number of max results.
#* @get /skills
function(res, req, limit = 100) {
	auth_helper(res, req, function(limit) {
		luxJob::get_skills(as.numeric(limit))
	}, limit = limit)
}

#* Get a skill by ID.
#* @param skill_id:string The ID of a particular skill.
#* @get /askill
function(res, req, skill_id) {
	auth_helper(res, req, function(skill_id) {
		luxJob::get_skill_by_id(skill_id)
	}, skill_id = skill_id)
}

#* Get all companies.
#* @param limit:number The number of max results.
#* @get /companies
function(res, req, limit = 100) {
	auth_helper(res, req, function(limit) {
		luxJob::get_companies(as.numeric(limit))
	}, limit = limit)
}

#* Get the details of a company.
#* @param company_id:integer The ID of a particular company.
#* @get /companydetails
function(res, req, company_id) {
	auth_helper(res, req, function(company_id) {
		luxJob::get_company_details(as.integer(company_id))
	}, company_id = company_id)
}

#* Get a filtered vacancy list.
#* @param company_id:integer The ID of a particular company.
#* @param skill:string The skill.
#* @param canton:string The canton.
#* @param limit:integer The max number of results.
#* @get /vacancies
function(res, req, skill=NULL, company_id=NULL, canton=NULL, limit=100) {
	auth_helper(res, req, function(skill, company_id, canton, limit) {
		luxJob::get_vacancies(skill, company_id, canton, as.integer(limit))
	}, skill = skill, company_id = company_id, canton = canton, limit = limit)
}

#* Get vacancy by ID.
#* @param vacancy_id:integer The ID of a particular vacancy.
#* @get /vacancy
function(res, req, vacancy_id) {
	auth_helper(res, req, function(vacancy_id) {
		luxJob::get_vacancy_by_id(as.integer(vacancy_id))
	}, vacancy_id = vacancy_id)
}

#* Get learning tracks.
#* @param skill:string The ID of a particular skill.
#* @get /learningtracks
function(res, req, skill = NULL) {
	auth_helper(res, req, function(skill) {
		luxJob::get_learning_tracks(skill)
	}, skill = skill)
}

#* Get a particular learning track.
#* @param track_id:integer The ID of a particular learning track.
#* @get /learningtrack
function(res, req, track_id = NULL) {
	auth_helper(res, req, function(track_id) {
		luxJob::get_learning_track_by_id(as.integer(track_id))
	}, track_id = track_id)
}

#* Get a filtered list of books.
#* @param skill:string The particular skill.
#* @get /books
function(res, req, skill = NULL) {
	auth_helper(res, req, function(skill) {
		luxJob::get_books(skill)
	}, skill = skill)
}

#* Get a particular book.
#* @param book_id:integer The ID of a particular book.
#* @get /book
function(res, req, book_id = NULL) {
	auth_helper(res, req, function(book_id) {
		luxJob::get_book_by_id(as.integer(book_id))
	}, book_id = book_id)
}

#* Post a search into the log system.
#* @param user_id:integer The ID of a particular user.
#* @param query:string The search string to send to the log.
#* @post /log
function(res, req, user_id=NULL, query=NULL) {
	auth_helper(res, req, function(user_id, query) {
		return(luxJob::log_search(as.integer(user_id), query))
	}, user_id = user_id, query = query)
}

#* Add two numbers. # This is just a stupid simple endpoint for testing POST requests.
#* @param a:integer A number.
#* @param b:integer Another number.
#* @post /add
function(res, req, a, b) {
	auth_helper(res, req, function(a, b) {
		return(as.integer(a)+as.integer(b))
	}, a = a, b = b)
}
