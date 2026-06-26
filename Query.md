Hash Join  (cost=27.09..41.32 rows=7 width=274) (actual time=0.079..0.084 rows=3.00 loops=1)
  Hash Cond: (p.product_id = oi.product_id)
  Buffers: shared hit=2
  ->  Seq Scan on products p  (cost=0.00..13.00 rows=300 width=222) (actual time=0.013..0.014 rows=6.00 loops=1)
        Buffers: shared hit=1
  ->  Hash  (cost=27.00..27.00 rows=7 width=28) (actual time=0.053..0.053 rows=3.00 loops=1)
        Buckets: 1024  Batches: 1  Memory Usage: 9kB
        Buffers: shared hit=1
        ->  Seq Scan on order_items oi  (cost=0.00..27.00 rows=7 width=28) (actual time=0.044..0.046 rows=3.00 loops=1)
              Filter: (order_id = 1)
              Rows Removed by Filter: 3
              Buffers: shared hit=1
Planning:
  Buffers: shared hit=6
Planning Time: 0.238 ms
Execution Time: 0.112 ms

Here is the execution plan for the query that retrieves all products from one order. 
As you can see, it performs a Seq Scan first on order_items, filtering those whose order_id is one.
Then, it makes another Seq Scan of Products, and makes a Hash Join. So, Postgre does two Sequential Scans and 
two Hash Joins throughout this query.