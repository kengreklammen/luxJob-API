library(httr2)

req <- request("http://127.0.0.1:8008/log")

req |> req_body_json(list(user_id = 4, query = "avionics"))
#> <httr2_request>
#> POST https://r-project.org
#> Body: json encoded data
#> 
resp <- req_perform(req)
resp