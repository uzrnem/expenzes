SELECT act.id, act.amount, act.event_date, act.remarks, act.created_at, act.updated_at,
     fa.name as from_account, ta.name as to_account, tags.name as tag,
     transaction_types.name as transaction_type, p.previous_balance, p.balance
FROM `activities` as act
LEFT JOIN `tags` ON `tags`.`id` = `act`.`tag_id`
LEFT JOIN `transaction_types` ON `transaction_types`.`id` = `act`.`transaction_type_id`
LEFT JOIN `passbooks`as p ON `p`.`activity_id` = `act`.`id`
LEFT JOIN accounts as fa ON fa.id = act.from_account_id
LEFT JOIN accounts as ta ON ta.id = act.to_account_id
ORDER BY `act`.`event_date` DESC, `act`.`id` DESC LIMIT 100


id 33 -- change to account for yes, sbi
id 18 --salary

select * from accounts;
select * from snapshots;
saving	credit	loan	invest	deposit	donate	wallet
29376.33	-34074.94	-44723.23	17500.00	138500.00	0.00	9805.20
update snapshots set event_date = '2020-11-30'
select * from expenze.snapshots 

INSERT INTO expenze_test.activities
SELECT * FROM expenze.activities;







SELECT act.id, act.amount, act.event_date, act.remarks, act.created_at, act.updated_at,
             fa.name as from_account, ta.name as to_account, tags.name as tag,oot
             transaction_types.name as transaction_type, fp.previous_balance, fp.balance, tp.previous_balance, tp.balance
        FROM `activities` as act
        LEFT JOIN `tags` ON `tags`.`id` = `act`.`tag_id`
        LEFT JOIN `transaction_types` ON `transaction_types`.`id` = `act`.`transaction_type_id`
        LEFT JOIN `passbooks`as fp ON `fp`.`activity_id` = `act`.`id` and act.from_account_id = fp.account_id
        LEFT JOIN `passbooks`as tp ON `tp`.`activity_id` = `act`.`id` and act.to_account_id = tp.account_id
        LEFT JOIN accounts as fa ON fa.id = act.from_account_id
        LEFT JOIN accounts as ta ON ta.id = act.to_account_id
        where act.tag_id = 4
        ORDER BY `act`.`event_date` DESC, `act`.`id` DESC LIMIT 100
        
--portition over
--rownumber over

select
 if (grouping (a.name), at.name, a.name) account_name,
 at.name, a.name,sum(amount) total
from accounts a
left join account_types at on at.id = a.account_type_id
group by at.name,a.name WITH ROLLUP;

