#!/usr/local/bin/perl

use strict;
use warnings;
use utf8;
use Encode 'decode', 'encode';
#use DBD::SQLite;
#use DBI;
use DateTime;
use DateTime::Format::Strptime;

#
# Usage (cf. init.sh)
#
#$ sqlite3 -csv chores.db [select_statement] | sed s/\"//g | ./create_select_options.pl [r_w|r_m|r_y|i_w|i_m|i_y]
#


#たとえば、「前回の実行」が2016-09-10で今日が2016-09-15だとすると、
#5日経過している。
#周期が3日のタスクなら、(2016-09-15 - (2016-09-10 + 3)) = 2日超過
#周期が5日のタスクなら、(2016-09-15 - (2016-09-10 + 5)) = 0日超過
#周期が7日のタスクなら、(2016-09-15 - (2016-09-10 + 7)) = -2 つまりまだ2日余裕がある。

if ($#ARGV!=0) {
	die "Option: [r_w|r_m|r_y|i_w|i_m|i_y] (error: $#ARGV)\n";
}
my $dt_today = DateTime->now;
my $str_today = $dt_today->ymd('-'); #yyyy-mm-ddの形の文字列で「今日」を表す
my $strp = DateTime::Format::Strptime->new(
    pattern => '%Y-%m-%d' # 文字列のパターンを指定 (後でパーズに使う)
);

while (<STDIN>) { #うっかり単に<>と書いているとダメ。Can't open r_w: No such file or directory at ./create_select_options.pl line 34.とか叱られる。
	chomp;
	my $mode=$ARGV[0];
	if ($mode eq 'r_w' || $mode eq 'r_m' || $mode eq 'r_y') {
		my ($id, $validity, $period, $what_to_do, $last_conducted_on) = split(/,/, decode('utf-8', $_));
		my $red_alert=0;
		if ($last_conducted_on eq '') { #前回行った日が不明ならとりあえず警告色
			$red_alert=1;
		} else { #前回の実行日が記録されている
			my $dt = $strp->parse_datetime($last_conducted_on);
			#前回の実行日 + 期間 = 次に行うべき日
			my $dt_next_to_be_done = $dt->clone->add(days => $period);
			my $str_next_to_be_done = $dt_next_to_be_done->ymd('-');
			#yyyy-mm-ddの文字列同士として比較すれば、どちらの日付が前かは分かる
			if ($str_next_to_be_done le $str_today) {
				$red_alert=1;
			}
		}
		print STDOUT ("<option value=\"" . $id . "\"");
		if ($red_alert==1) {
			print STDOUT " class=\"red\"";
		}
		print STDOUT encode('utf-8', " title=\"$period" . "日周期、前回は[$last_conducted_on]\">$what_to_do</option>\n");
	} elsif ($mode eq 'i_w' || $mode eq 'i_m' || $mode eq 'i_y') {
		my ($id, $validity, $to_be_done_by, $what_to_do, $conducted_on) = split(/,/, decode('utf-8', $_));
		my $red_alert=0;
		if ($to_be_done_by le $str_today) {
				$red_alert=1;
		}
		print STDOUT ("<option value=\"" . $id . "\"");
		if ($red_alert==1) {
			print STDOUT " class=\"red\"";
		}
		print STDOUT encode('utf-8', " title=\"目標期日は[$to_be_done_by]\">$what_to_do</option>\n");
	}
}
