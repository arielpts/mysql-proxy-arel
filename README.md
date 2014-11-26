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

```ruby
#arel
customer.select(*).where(customer[:name].eq('Ariel Patschiki'))
```

**Rewritten SQL**

```sql
SELECT * FROM `customer` WHERE `customer`.`name` = 'Ariel Patschiki'
```

### More Query

**Original SQL**

```ruby
#arel
customer.select(*). \
join(address).on(address[:id].eq(customer[:address_id])). \
where(customer[:name].eq('Ariel Patschiki'))
```

**Rewritten SQL**

```sql
SELECT *
FROM `customer`
INNER JOIN `address` ON `address`.`id` = `customer`.`address_id`
WHERE `customer`.`name` = 'Ariel Patschiki'
```

### Complex Query

**Original SQL**

```ruby
#arel

ids = [1, 2, 3]

c = customer.take(1)
ids.each do |customer_id|
	sql = customer.select(subscription[:value].sum). \
		join(subscription).on(subscription[:customer_id].eq(customer[:id])). \
		where(customer[:id].eq(customer_id)). \
		where(subscription[:status].eq('Confirmed')).to_sql

	c = c.project(Arel::Nodes::SqlLiteral.new('(' + sql + ')').as('id_' + customer_id.to_s))
end

c
```

**Rewritten SQL**

```sql
SELECT  (SELECT SUM(`subscription`.`value`) AS sum_id FROM `customer` INNER JOIN `subscription` ON `subscription`.`customer_id` = `customer`.`id` WHERE `customer`.`id` = 1 AND `subscription`.`status` = 'Confirmed') AS id_1, (SELECT SUM(`subscription`.`value`) AS sum_id FROM `customer` INNER JOIN `subscription` ON `subscription`.`customer_id` = `customer`.`id` WHERE `customer`.`id` = 2 AND `subscription`.`status` = 'Confirmed') AS id_2, (SELECT SUM(`subscription`.`value`) AS sum_id FROM `customer` INNER JOIN `subscription` ON `subscription`.`customer_id` = `customer`.`id` WHERE `customer`.`id` = 3 AND `subscription`.`status` = 'Confirmed') AS id_3 FROM `customer`  LIMIT 1
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