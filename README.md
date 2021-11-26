# places_alloverse_com
A web site where user accounts can be created and managed, and from those accounts, places can be created and managed. Landing page for when opening the app without an URL.

---

# PlacesAlloverseCom

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

# Run with Docker

`docker build -t alloverse_dashboard .`

And then

`docker run --publish 4000:4000 --env DATABASE_URL=ecto://user:pass@<my_ip>/db_name --env SECRET_KEY_BASE="somethingSecret" --rm -it alloverse_dashboard`

## Using local database on Mac

You need to have a postgres server installed on your computer. If you have a Mac, you can:

* brew install postgresql
* brew services start postgresql
* /usr/local/opt/postgres/bin/createuser -s postgres
* ... and THEN do the ecto setup etc from above.

If you're running from docker, you need to allow outside access:

Replace listen with listen = "*" in this file

`sudo pico /usr/local/var/postgres/postgresql.conf`

Add your ip address and trust in this file

`sudo pico /usr/local/var/postgres/pg_hba.conf`

Then restart postgress like this

`brew services restart postgres`


## Deployment

To deploy to our AWS hosted infrastructure we use Docker and Terraform.

The steps are the same for both development and prodcution environment:

1. Login
2. Docker build and tag
3. Docker push
4. Terraform taint
5. Terraform apply

### Development

1. `aws ecr get-login-password --region eu-north-1 | docker login --username AWS --password-stdin 976187562384.dkr.ecr.eu-north-1.amazonaws.com`

2. `docker build -t 976187562384.dkr.ecr.eu-north-1.amazonaws.com/dev_alloverse_dashboard:latest .`

3. `docker push 976187562384.dkr.ecr.eu-north-1.amazonaws.com/dev_alloverse_dashboard:latest`

4. In allo-infra/environments/dev `terraform taint module.dashboard.aws_ecs_task_definition.task_definition`

5. Then deploy with `terraform apply`


### Production

1. `aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 976187562384.dkr.ecr.eu-west-1.amazonaws.com`

2. `docker build -t 976187562384.dkr.ecr.eu-west-1.amazonaws.com/prod_alloverse_dashboard:latest .`

3. `docker push 976187562384.dkr.ecr.eu-west-1.amazonaws.com/prod_alloverse_dashboard:latest`

4. In allo-infra/environments/prod `terraform taint module.dashboard.aws_ecs_task_definition.task_definition`

5. Then deploy with `terraform apply`



## Learn more

  * Official website: http://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Mailing list: http://groups.google.com/group/phoenix-talk
  * Source: https://github.com/phoenixframework/phoenix

