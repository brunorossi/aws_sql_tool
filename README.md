# PostgreSQL + AWS Steampipe FDW + pREST

The tool provides you with the capability to query via SQL language
the resources deployed into several AWS accounts. Additionally,
you can expose the results of your queries via a read only REST API.

The tool is based on the underlying softwares: 

* [PostgreSQL](https://www.postgresql.org/)
* [PgAdmin](https://www.pgadmin.org/)
* [SteamPipe AWS Foreign Data Wrapper](https://www.postgresql.org/)
* [pREST](https://prestd.com/)

The code is intended to let you run the tool on your local machine with
the following softwares installed: 

* [Docker Engine](https://docs.docker.com/engine/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Git](https://git-scm.com/)

The tool has been tested on Ubuntu 20.04 LTS.

## Run the tool

```bash
# clone the repo
git clone 

# move into the repo
cd aws-sql-tool

# run
docker-compose up -d
```

## Open PgAdmin 

Open the PgAdmin console into the browser at the following URL: [http://127.0.0.1:5050](http://127.0.0.1:5050)

Fill the fields with the following credentials:

* Username: **pguser@domain-name.com**
* Password: **pgpass**

Click on Servers and fill the password field with the **pgpass** value

Select the *clouddetective* database into the left panel

Select *Query Tool* under the *Tool* drop down menu

Fill the editor with the following sql statements, change 
the <ACCESS_KEY>, <SECRET_KEY> placeholders with the ones of your AWS
account of choice:

```sql
DROP SERVER IF EXISTS steampipe_aws_account_1 CASCADE;

CREATE SERVER steampipe_aws_account_1 FOREIGN DATA WRAPPER steampipe_postgres_aws OPTIONS (config 'access_key="<ACCESS_KEY>"
secret_key="<SECRET_KEY>"
regions=["*"]');

DROP SCHEMA IF EXISTS aws_account_1 CASCADE;

CREATE SCHEMA aws_account_1;

COMMENT ON SCHEMA aws_account_1 IS 'steampipe aws fdw';

IMPORT FOREIGN SCHEMA aws_account_1 EXCEPT(aws_organizations_organizational_unit) FROM SERVER steampipe_aws_account_1 INTO aws_account_1;
```

Press the F5 button to run the statements.

Into the left panel, under the *clouddetective* database, open the 
*Schemas* label of the tree menu, open the *Foreign Tables* label 
of the tree menu and you should see several names related to 
different kind of AWS resources. 

Query a resource of you choice. For example, if you want to know 
which DynamoDb tables are deployed into your account across all regions
you can paste the following query:

```sql
SELECT * FROM aws_account_1.aws_dynamodb_table;
```

Press F5 button to run the query and get the results into the 
panel at the bottom of the screen.

## Expose results through REST API 

Run the followig query to create a VIEW that retrieves all the IAM users 
with MFA disabled:

```sql
CREATE VIEW aws_account_1.users_with_mfa_disabled AS 
SELECT * FROM aws_account_1.aws_iam_user WHERE mfa_enabled = false;
```

Open your browser and go to the following url: 
(http://127.0.0.1:3000/clouddetective/aws_account_1/users_with_mfa_disabled)[http://127.0.0.1:3000/clouddetective/aws_account_1/users_with_mfa_disabled]
to get the results of your query via REST API.


Cooked with love by [BR78](mailto:brunorossiweb@gmail.com)
