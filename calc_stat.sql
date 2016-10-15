.header ON
.mode column

.print '**********    2回以上行った作業についての簡易統計    **********'
.print '   [最初の実行日, 最終実行日, 実行回数, 平均間隔, ID, タスク名]'
.width 11 11 3 8 2 30

select 
	min(r.conducted_on) as first, 
	max(r.conducted_on) as last, 
	count(r.reg_chore_id) as num, 
	printf("%2.3f", (julianday(date(max(r.conducted_on))) - julianday(date(min(r.conducted_on)))) / (count(r.reg_chore_id) -1)) as interval,
	r.reg_chore_id as ID,  
	i.what_to_do as task
from regular_chores_rec as r, regular_chores_idx as i
where r.reg_chore_id=i.reg_chore_id
group by r.reg_chore_id having count(r.reg_chore_id) > 1
order by (julianday(date(max(r.conducted_on))) - julianday(date(min(r.conducted_on)))) / (count(r.reg_chore_id) -1) desc;

.print ' '
.print '********  1回だけ行った作業の一覧  ********'
.print '  [実行日, 定期/非定期の種別, ID, タスク名]'
.width 11 4 3 40
select min(r.conducted_on) as date, 'Reg' as typ, r.reg_chore_id as ID, i.what_to_do as task
from regular_chores_rec as r, regular_chores_idx as i
where r.reg_chore_id=i.reg_chore_id
group by r.reg_chore_id having count(r.reg_chore_id) = 1
union
select conducted_on as date, 'Irr' as typ, irr_chore_id as ID, what_to_do as task
from irregular_chores_idx
where conducted_on is not null and conducted_on is not ''
order by date desc;
