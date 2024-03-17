import argv
import gleam/io
// 
import restcountries_api
import country

pub fn main() {
  case argv.load().arguments {
    ["get", name] -> {
      let json_string = get(name)
      let decoded = country.countries_from_json(json_string)
      io.debug(decoded)
      io.println("_")
    }
    _ -> {
      io.println("Usage: country_quiz get <name>")
    }
  }
}

fn get(name: String) {
  let res = restcountries_api.get_country(name)
  case res {
    Ok(value) -> value.body
    _ -> "Error :("
  }
}

pub fn format_pair(name: String, value: String) -> String {
  name <> "=" <> value
}
