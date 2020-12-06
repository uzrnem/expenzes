SELECT act.id, act.amount, act.event_date, act.remarks, act.created_at, act.updated_at,
     fa.name as from_account, ta.name as to_account, tags.name as tag,
     transaction_types.name as transaction_type
    FROM `activities` as act
    LEFT JOIN `tags` ON `tags`.`id` = `act`.`tag_id`
    LEFT JOIN `transaction_types` ON `transaction_types`.`id` = `act`.`transaction_type_id`
    LEFT JOIN accounts as fa ON fa.id = act.from_account_id
    LEFT JOIN accounts as ta ON ta.id = act.to_account_id
    ORDER BY `act`.`event_date` DESC, `act`.`id` DESC LIMIT 30
id 33 -- change to account for yes, sbi
id 18 --salary

select * from accounts;
select * from snapshots;
saving	credit	loan	invest	deposit	donate	wallet
29376.33	-34074.94	-44723.23	17500.00	138500.00	0.00	9805.20
update snapshots set event_date = '2020-11-30'
select * from expenze.snapshots 