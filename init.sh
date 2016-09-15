#!/bin/sh

#(cat fragment_1.html fragment_2.html fragment_3.html fragment_4.html fragment_5.html fragment_6.html fragment_7.html; echo "<option value=\"`date -v-2d '+%Y-%m-%d'`\">`date -v-2d '+%Y-%m-%d'`</option>\n<option value=\"`date -v-1d '+%Y-%m-%d'`\">`date -v-1d '+%Y-%m-%d'`</option>\n<option value=\"`date '+%Y-%m-%d'`\">`date '+%Y-%m-%d'`</option>"; cat fragment_8.html; date '+%Y-%m-%d %H:%M:%S'; cat fragment_9.html) > index.html


(cat fragment_1.html; \
 (sqlite3 -csv chores.db \
  "select * from regular_chores_idx where validity=1 and period <= 7 order by last_conducted_on, period;" | \
  sed s/\"//g | ./create_select_options.pl r_w); \
 cat fragment_2.html; \
 (sqlite3 -csv chores.db \
  "select * from regular_chores_idx where validity=1 and 7 < period and period <= 31 order by last_conducted_on, period;" | \
  sed s/\"//g | ./create_select_options.pl r_m); \
 cat fragment_3.html; \
 (sqlite3 -csv chores.db \
  "select * from regular_chores_idx where validity=1 and 31 < period order by last_conducted_on, period;" | \
  sed s/\"//g | ./create_select_options.pl r_y); \
 cat fragment_4.html; \
 (sqlite3 -csv chores.db \
  "select * from irregular_chores_idx where validity=1 and conducted_on is not '' and to_be_done_by <= date('now', '+7 days') order by to_be_done_by;" | \
  sed s/\"//g | ./create_select_options.pl i_w); \
 cat fragment_5.html; \
 (sqlite3 -csv chores.db \
  "select * from irregular_chores_idx where validity=1 and conducted_on is not '' and date('now', '+7 days') < to_be_done_by and to_be_done_by <= date('now', '+31 days') order by to_be_done_by;" | \
  sed s/\"//g | ./create_select_options.pl i_m); \
 cat fragment_6.html; \
 (sqlite3 -csv chores.db \
  "select * from irregular_chores_idx where validity=1 and conducted_on is not '' and date('now', '+31 days') < to_be_done_by order by to_be_done_by;" | \
  sed s/\"//g | ./create_select_options.pl i_y); \
 cat fragment_7.html; \
 echo "<option value=\"`date -v-2d '+%Y-%m-%d'`\">`date -v-2d '+%Y-%m-%d'`</option>\n<option value=\"`date -v-1d '+%Y-%m-%d'`\">`date -v-1d '+%Y-%m-%d'`</option>\n<option value=\"`date '+%Y-%m-%d'`\" selected>`date '+%Y-%m-%d'`</option>"; \
 cat fragment_8.html; \
 date '+%Y-%m-%d %H:%M:%S'; \
 cat fragment_9.html) > index.html


#"select * from regular_chores_idx where validity=1 and period <= 7 order by case when last_conducted_on is '' or last_conducted_on is null then '0000-xx-xx' else last_conducted_on end, period;"