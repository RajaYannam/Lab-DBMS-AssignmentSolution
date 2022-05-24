select * from supplier_pricing;
use lab4;

select count(customer.cus_gender)from customer join orders on customer.cus_id=orders.CUS_ID 
and ORD_AMOUNT>=3000 group by customer.CUS_GENDER ;

select * from orders join customer on orders.cus_id=customer.cus_id having customer.cus_id=2;

select pro.PRO_NAME,o.ORD_AMOUNT,o.ORD_DATE
from orders o
join supplier_pricing sp
on o.pricing_id=sp.pricing_id
join product pro
on pro.pro_id=sp.pro_id
where o.cus_id=2;

select * from supplier where supp_id in(select supp_id from supplier_pricing
 group by supp_id having count(supp_id)>1);
 
 select cat.cat_id,min(t2.supp_price) as price from category cat inner join
 (select * from product p inner join
 (select pro_id as id ,supp_price from supplier_pricing group by id having min(supp_price))as t1 on t1.id=p.pro_id)
 as t2 on t2.cat_id=cat.cat_id group by cat.cat_id;
 
 select pro_id,pro_name from product as prod inner join(select o.ord_date from orders as o inner join supplier_pricing as sp on sp.pricing_id=o.pricing_id and
 o.ord_date>"2021-10-05") as p1 on prod.pro_id=p1.PRO_ID;
 
 select cus_name,cus_gender from customer where cus_name like '%A' or cus_name like 'A%';
 
 Delimiter &&
 create procedure proc()
 begin
 select report.supp_id,report.supp_name,report.average,
 case
 when report.average=5 then 'Excellent Service'
 when report.average>4 then 'Good Service'
 when report.average>2 then 'Average Service'
 else 'Poor Service'
 end as Type_of_Service from
 (select final.supp_id,final.average,supplier.supp_name from 
 (select test2.supp_id,sum(test2.rat_ratstars)/count(test2.rat_ratstars) as average from 
 (select supplier_pricing.supp_id,test.ord_id,test.rat_ratstars from supplier_pricing inner join
 (select orders.pricing_id,rating.ord_id,rating.rat_ratstars from orders
 inner join rating on rating.ord_id=orders.ord_id)
 as test on test.pricing_id=supplier_pricing.pricing_id)
 as test2 group by supplier_pricing.supp_id)
 as final inner join supplier on final.supp_id=supplier.supp_id) as report;
 end &&
 Delimiter ;
 
 exec proc where average=5;
