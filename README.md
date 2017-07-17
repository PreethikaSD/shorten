# README

To use API to get the shortened link here is an example:

curl -H "Content-Type: application/json" -d '{"link": {"long_link": "https://www.google.com.sg"}}' -X POST http://localhost:3000 -i 


Assumptions: 
* A link will be shortened once. If link has already been shortened, the same will be returned back.
* Through API, the params to be sent are long link.
* In web, the params needed to shorten link are username and long link.
