# Geolocation API
Ruby API - Geolocation with external integration


## How to run project in Docker container

**1. build image**
> docker-compose build

**2. run image**
> docker-compose up


### How to interact with API via Postman

[//]: # (**1. visit deployed app on next link**)
[//]: # (> https://geospatial-app-rngt.onrender.com/)

[//]: # (**2. send request with new ticket data to the API server with JSON body that can be the same as in example**)
[//]: # (> POST https://geospatial-app-rngt.onrender.com/api/v1/tickets)

[//]: # (**3. open new ticket card on webb-app page to see all details and plotted polygons on the map**)
[//]: # (> https://geospatial-app-rngt.onrender.com/tickets/1)


## Steps of implementation and developer notes

**1. Understand the Requirements:**
> - carefully read and understood the problem definition.
> - identified the core functionalities the API should provide: managing doctor availabilities, patient booking/editing appointments, and viewing availability.

**2. Select the Technology Stack:**
> - chose the programming language and framework.
>   - RoR, PostgreSQL, Docker-Compose, JWT, Pundit, DRY-validation, Alba, Faraday, Swagger, RSpec, FactoryBot

**3. Design DB & implement Models:**
> - determined the data models required for this system.
> - created `Geolocation` model with:
>   - required `ip` string attribute;
>   - optional `url` string attribute;
>   - string `type` attribute;
>   - float `latitude` and `longitude` attributes;
>   - jsonb `location` attribute with all additional data received from 3rd party service.
> - perhaps, create separate related table to store `location` JSON data there, TBD...
> - created two **indexes** for `ip` and `url` (for second one only for cases when value is present) columns.
> - added default Rails validation on model layer via creating own validators.

[//]: # (> - implement main model for storing geospatial data using `postgis` gem)
[//]: # (> - design and use `Service Object` to encapsulate and manage business logic in separate abstraction)
[//]: # (>   - service objects represent a single system action such as adding a record to the database or sending an email)
[//]: # (>   - service objects should contain no reference to anything related to HTTP, such as requests or parameters)
[//]: # (> - implement `Query Object` on `show_open_slots` endpoint to handle complicated querying of records collection on index endpoint with extend filtering params and potentially ordering ones)
[//]: # (> - final DB schema with relations is next &#40;see screenshot below&#41;)
[//]: # (> - seed DB with default data)

**4. API Endpoints:**

[//]: # (> - define the API endpoints based on the requirements.)
[//]: # (> - ensure that the API follows RESTful principles &#40;HTTP methods like GET, POST, PUT, DELETE, status codes, etc.&#41;.)
[//]: # (> - create CRUD endpoints for ability to manage available slot in doctors schedule)
[//]: # (> - use `Alba` gem for serialization)
[//]: # (>   - potentially we can convert all keys to `lowerCamelCase` adding one command in base serializer)
[//]: # (> - it is first version of `V1` API, so we have to consider add `/v1` into path and move controllers into `V1` module according to the best practices of API design and implementation)
[//]: # (> - use JSON API standard for request payloads and response bodies)

**5. Integration with IPstack 3rd party service:**
> - created simple class to call `IPstack` 3rd party service using `Faraday` gem.

[//]: # (> - create separate service to handle errors and transfor response)
[//]: # (> - potentially rewrite that class to servie object)

**6. Authentication and Authorization:**

[//]: # (> - Implement user authentication to ensure only authorized users can book or modify appointments.)
[//]: # (> - use `JWT` gem to authentication users)
[//]: # (> - create simple `login` endpoint to authenticate current user by JWT)
[//]: # (> - use `Pundit` gem to authorise users permissions)

**7. Validation and Error Handling:**
> - added default Rails validation on model layer via creating own validators.

[//]: # (> - add validation for incoming data to prevent invalid bookings or data corruption.)
[//]: # (>   - use `Dry-validation` gem)
[//]: # (>   - add addition DRY rules for cases when slots time data is not valid)
[//]: # (> - implement robust error handling to provide meaningful error messages through whole API.)
[//]: # (>   - we are able not pass error message to response body if we don't want to show any internal errors in clients)

**8. Documentation:**

[//]: # (> - created this README.md file that explains how to run and use the service.)
[//]: # (> - added developer notes that were written during implementation)
[//]: # (> - included Postman collection into project for sharing with other team members)
[//]: # (>   - here is short description about all created endpoints)

**9. Testing:**

[//]: # (> - write couple model unit tests to ensure the reliability of your code)
[//]: # (> - cover all endpoint with own integration test using Swagger framework and generate very useful and helpful documentation)
[//]: # (>   - visit `<server>/api-docs` you can see automatically generated API documentation like on screenshot above)
[//]: # (> - use `simplecov` gem to check amount of covered code with tests)

**10. Deployment:**
> - built API application inside of docker container and use `Docker Compose` tool manage it with DB in separate one.

**11. Future Improvements:**
> - **Logging**: Implement logging to track API requests and responses for debugging purposes.
> - **Rate Limiting**: Consider implementing rate limiting to prevent abuse.
> - **Caching**: Implement caching for repeated requests to improve performance.
> - use secrets to manage important environment variables.
> - perhaps, create separate table to store `location` JSON data there and add one-to-one relation to `geolocation` table...
> - add background job to fetch and store data about IP or URL not existing in DB in new `geolocation` record.
