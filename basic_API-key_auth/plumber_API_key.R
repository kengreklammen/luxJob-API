# Sajna ez az egesz szarsag nem mukodik.

source("basic_API-key_auth/auth_helper.R")

#* @apiTitle Basic API-key authentication

#* Add two numbers
#* @param a:number The first number to add.
#* @param b:number The second number to add.
#* @get /add
function(res, req, a, b) {
	auth_helper(
		res,
		req,
		as.numeric(a) + as.numeric(b)
	)
}

#* Echo the parameter that was sent in
#* @param msg:string  The message to echo back.
#* @get /echo
function(res, req, msg="") {
	auth_helper(
		res,
		req,
		list(msg = paste0("The message is: '", msg, "'"))
	)
}