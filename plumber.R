library(plumber)
# plumber.R


#* @apiTitle Basic Plumber API
#* @apiDescription This is a simple API to demonstrate the use of plumber.
#* @apiVersion 1.0.0
#* @apiContact pierrick.kinif@datagrowth.io
#* @apiLicense MIT

#* Echo the parameter that was sent in
#* @param msg:string  The message to echo back.
#* @get /echo
function(msg=""){
	list(msg = paste0("The message is: '", msg, "'"))
}

#* Add two numbers
#* @param a:number The first number to add.
#* @param b:number The second number to add.
#* @get /add
function(a, b) {
	as.numeric(a) + as.numeric(b)
}

#* Plot out data from the iris dataset - without error handling
#* @param spec:string If provided, filter the data to only this species (e.g. 'setosa')
#* @get /plot
#* @serializer png
function(spec){
	myData <- iris
	title <- "All Species"
	
	# Filter if the species was specified
	if (!missing(spec)) {
		title <- paste0("Only the '", spec, "' Species")
		myData <- subset(iris, Species == spec)
	}
	
	plot(myData$Sepal.Length, myData$Petal.Length,
			 main = title, xlab = "Sepal Length", yla = "Petal Length")
}

#* Multiply two numbers
#* @param a:number The first number to multiply.
#* @param b:number The second number to multiply.
#* @get /mul
function(a, b) {
	as.numeric(a) * as.numeric(b)
}

#* @filter log
function(req, res) {
	print(req$HTTP_USER_AGENT) # Just to print some info about the client computer.
	token <- req$HTTP_AUTHORIZATION
	if(is.null(token)){
		res$status <- 401
		return(list(error = "Missing token"))
	}
	list(status = "Access granted")
	forward()
}