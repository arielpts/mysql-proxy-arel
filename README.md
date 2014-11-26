# MySQL Proxy for Arel
## What?
A little **experient** written in Lua and Ruby that enables you to perform [Arel](https://github.com/rails/arel) "SQL" from your favorite MySQL tool:

### Screenshot (OK)
![image](https://arielpts.s3.amazonaws.com/mysql-proxy-arel/query-ok2.png)

### Screenshot (Returned Ruby Error)
![image](https://arielpts.s3.amazonaws.com/mysql-proxy-arel/query-error.png)

## Arel to SQL Samples

### Simple Query

**Original "SQL"**

```
#arel
customer.select(*).where(customer[:name].eq('Ariel Patschiki'))
```

**Rewritten SQL**

```
SELECT * FROM `customer` WHERE `customer`.`name` = 'Ariel Patschiki'
```

### Complex Query

**Original SQL**

```
#arel
customer.select(*). \
join(address).on(address[:id].eq(customer[:address_id])). \
where(customer[:name].eq('Ariel Patschiki'))
```

**Rewritten SQL**

```
SELECT *
FROM `customer`
INNER JOIN `address` ON `address`.`id` = `customer`.`address_id`
WHERE `customer`.`name` = 'Ariel Patschiki'
```

## How?

1. Install MySQL Proxy. Eg.: `brew install mysql-proxy`
2. `bundle`
2. `./start.sh`
3. Connect using port `3307` instead of `3306`
4. Start your queries with `#arel`

## Syntax Sugar
- Replaces `*` by `Arel.sql('*')`
- Method Missing `my_table_name` to `Arel::Table.new(:my_table_name)`
- More intuitive method names: `select` instead of `project`