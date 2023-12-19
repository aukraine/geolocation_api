# Geolocation API
Ruby API - Geolocation with external integration


## How to run project in Docker container

**1. build image**
> docker-compose build

**2. create, migrate and seed DB**
> docker-compose exec api bin/rails db:rebuild

**3. run image**
> docker-compose up

**4. run tests (optional)**
> docker-compose exec api rspec spec


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
> - `url` attribute will have a role like a caching layer to avoid redundant heavy call to external service in case if we already know which IP address is related.
> - perhaps, create separate related table to store `location` JSON data there, TBD...
> - created two **indexes** for `ip` and `url` (for second one only for cases when value is present) columns for faster searching.
> - created uniqueness index for `ip` column to avoid duplicated records in DB.
>   - stored only uniq records by IP or URL value.
>   - managed cases when there is already record with given IP but with empty URL value.
> - added default Rails validation on model layer via creating own validators.
> - implemented `find_by_ip_or_url` scope to search by target value in both attributes via one query.
> - created simple `User` model to be able use and show `Pundit` authorization.
> - ~~implement main model for storing geospatial data using `postgis` gem.~~
> - design and use `Service Object` to encapsulate and manage business logic in separate abstraction.
>   - service objects represent a single system action such as adding a record to the database or sending an email.
>   - service objects should contain no reference to anything related to HTTP, such as requests or parameters.
> - seeded DB with default data.
> - created complex `db:rebuild` rake task to run all DB related commands per one time.

[//]: # (> - final DB schema with relations is next &#40;see screenshot below&#41;.)

**4. API Endpoints:**

> - defined the API endpoints based on the requirements.
> - ensured that the API follows RESTful principles (HTTP methods like GET, POST, PUT, DELETE, status codes, etc.).
> - create couple of CRUD endpoints for ability to manage geolocations records.
> - it's first version `V1` of API, so we added `/v1` into path and moved controllers into `V1` module according to the best practices of API design and implementation.
> - used `:target` params as default instead `:id` on **show** and **destroy** endpoints.
>   - moreover, allowed `target` value to contain IP addresses, domains and even URLs with prefixes via set up the constraints,
>   - note that integrated `IPstack` service works only with domain addresses in path, so ability to receive, validate and store whole URL addresses will be useful in the future,
>     - use `%2F` combination instead single `/` in case when need to pass URL prefix, for instance `https://<domain>`.
>   - need to dive deeper into ability to receive, validate and handle two separate properties in request payloads for `IP` and `URL` values instead one common `target` as is implemented now, TBD...
> - used `Alba` gem for serialization.
>   - potentially we can convert all keys to `lowerCamelCase` adding one command in base serializer.
> - used `JSON API` standard for request payloads and response bodies.
> - used `Swagger` framework to test and create automatic-generated documentation.

**5. Integration with IPstack 3rd party service:**
> - created simple class to call `IPstack` 3rd party service using `Faraday` gem.
> - created separate class to handle errors and transform response.
> - implemented these classes as agnostic abstraction and used inside of only one service object for better potential replacing with another integration.

**6. Authentication and Authorization:**
> - implemented user authentication to ensure only authorized users can interact with Geospatial data.
> - used `Pundit` gem to authorise users permissions.

[//]: # (> - use `JWT` gem to authentication users)
[//]: # (> - create simple `login` endpoint to authenticate current user by JWT)

**7. Validation and Error Handling:**
> - added default Rails validation on model layer via creating own validators.
> - implemented robust error handling to provide meaningful error messages through whole API.
>   - handled multi error cases according to JSON API specification, especially for contract and model validations when there might be several errors.
>   - it is possible not pass error message to response body if we don't want to show any exactly internal errors in client side.
> - added validation for incoming data to prevent processing requests with invalid payloads.
>   - used `Dry-validation` gem and created a short contract.
>   - added addition DRY rule to verify if one property contains any of both value formats.

**8. Documentation:**

[//]: # (> - created this README.md file that explains how to run and use the service.)
[//]: # (> - added developer notes that were written during implementation)
[//]: # (> - included Postman collection into project for sharing with other team members)
[//]: # (>   - here is short description about all created endpoints)

**9. Testing:**
> - used `FactoryBot` gem and created factories for each model
> - wrote couple unit tests to ensure the reliability of the code.
>   - created **models** specs.
>   - added **validators** own specs.
>   - created **error handler** and **error objects** unit tests.
>   - added **contract** own specs.
>   - created specs for `IPstack` lib classes.
>   - added **service object** specs.
> - use `simplecov` gem to check amount of covered code with tests.

[//]: # (> - cover all endpoint with own integration test using Swagger framework and generate very useful and helpful documentation)
[//]: # (>   - visit `<server>/api-docs` you can see automatically generated API documentation like on screenshot above)
[//]: # (>   - add screenshot about test coverage into documantation)

**10. Deployment:**
> - built API application inside of docker container and use `Docker Compose` tool manage it with DB in separate one.

**11. Future Improvements:**
> - **Logging**: Implement logging to track API requests and responses for debugging purposes.
>   - use common Rails approach or integrate any 3rd party service, aka `Rollbar` or `CloudWatch`.
> - **Rate Limiting**: Consider implementing rate limiting to prevent abuse.
> - **Caching**: Implement caching for repeated requests to improve performance.
> - **Notifying**: Consider integrate emailing outside app to better notification of different events.
> - use secrets to manage important environment variables.
> - perhaps, create separate table to store `location` JSON data there and add one-to-one relation to `geolocation` table...
> - instead using self-written regexp for URLs, discover any solution out of the box for better contract and model validations.
> - add background job to fetch and store data about IP or URL not existing in DB in new `geolocation` record.
> - hide internal 500th errors and not send them in response body.
>   - refactor base error class to work with the errors array more natively.
> - implement different user policy scopes according to new roles data modeling, for instance.
> - potentially implement ability to use other 3rd party service for receiving location data with managing whole URL addresses instead just domain part now.
> - maybe at least in `V2` version of API it would be better to manage and process different properties in request payload for IP and URL values instead one common.
> - add on `index` page at least **pagination** to avoid too long responses if there are a lot of records in DB.
