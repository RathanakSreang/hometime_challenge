# Hometime Reservation API

### Hometime API parse JSON payload from third party service within single endpoint.

### Documentation

#### 1. Payload mapping

We use `YML` file to store mapped field of each payload. This file is saved in `config/yml/reservation_payload.yml` where we could add more payload in future.


### Development
#### 1. Using docker

You need to have `Docker` install

- Setup
```
chmod +x entrypoint
docker-compose up -d
docker-compose exec api bundle exec rake db:setup db:migrate # first time run server
docker-compose down
docker-compose up
```

- Test
```
docker-compose up -d
docker-compose exec api bundle exec rspec
```

- API doc
```
docker-compose up -d
docker-compose exec api bundle exec rake rswag:specs:swaggerize
```
Access API doc
`http://localhost:3000/api-docs/index.html`


#### 2.Using your local machine
You need to have `ruby-3.1.2`,  `rails-7.0.3`, `PostgreSQL 9.5`

- Configure database:
Setup database: Make you already install postgrest - `sudo -i -u postgres` - login to postgrest `psql` - the create user hometime_user
`CREATE ROLE hometime_user WITH SUPERUSER CREATEDB LOGIN ENCRYPTED PASSWORD 'RathanakPassword';`

- Start server:
```
cd hometime
bundle install
rails db:setup db:migrate
rails s
```

- run test
```
rspec .
```

- run guard
```
bundle exec guard
```

- run rubocop
```
rubocop
```

- API doc
Generate API Doc
```sh
rake rswag:specs:swaggerize
```

Access API doc
`http://localhost:3000/api-docs/index.html`

### Deployment

#### 1. Heroku
