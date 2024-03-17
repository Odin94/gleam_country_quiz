import gleam/result
import gleam/httpc
import gleam/http/request
import gleam/http/response
import gleeunit/should

pub fn get_country(country: String) {
  // Prepare a HTTP request record
  let assert Ok(request) =
    request.to("https://restcountries.com/v3.1/name/" <> country)

  // Send the HTTP request to the server
  use resp <- result.try(httpc.send(request))

  // We get a response record back
  resp.status
  |> should.equal(200)

  resp
  |> response.get_header("content-type")
  |> should.equal(Ok("application/json"))

  resp.body

  Ok(resp)
}
