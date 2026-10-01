select
	payment_method,
	count(*) as "num"
from orders
group by payment_method