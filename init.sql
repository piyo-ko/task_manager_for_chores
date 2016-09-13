-- 定期的／継続的タスク
create table if not exists regular_chores_idx (
	reg_chore_id integer primary key, -- タスクID
	period integer, -- 周期
	what_to_do text, --タスク名
	last_conducted_on text -- 前回行った日 (YYYY-MM-DD)。ここだけ更新あり。
);

-- regular_chores_idx.last_conducted_on だけで十分な気もするが、
-- 後で統計を取りたくなるかもしれないので、とりあえず個別の実行日も記録する。
create table if not exists regular_chores_rec (
	reg_chore_id integer, -- タスクID
	conducted_on text -- 行った日
);

-- 非定期／単発タスク
create table if not exists irregular_chores_idx (
	irr_chore_id integer primary key, -- タスクID
	to_be_done_by text, -- 一応の期限 (YYYY-MM-DD)。
	what_to_do text, --タスク名
	conducted_on text -- 行った日
);
