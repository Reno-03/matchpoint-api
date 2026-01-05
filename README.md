# MatchPoint GraphQL Backend API

## Make sure to have the following installed:

- Ruby (version specified in the Rails app)
- Rails
- Bundler
- PostgreSQL

Verify:
```sh
ruby -v
rails -v
psql --version
```

### Rails GraphQL API Setup
```sh
cd matchpoint-api
bundle install
rails db:create db:migrate db:seed
rails server
```

The Rails GraphQL API will be available at:
```sh
http://localhost:3000/graphql
```
