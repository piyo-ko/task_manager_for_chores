var cmd_str="";

function record_finished_task() {
  var d=document.in.date_when_task_finished.value;

  var task_types=document.in.finished_task_type;
  var which_type;
  for (var i=0; i<task_types.length; i++) {
    if (task_types[i].checked) {
      which_type=task_types[i].value;
      break;
    }
  }

  var op_list=document.getElementById(which_type + '_tasks');
  var task=op_list.options[op_list.selectedIndex].value;

  var sql="";
  if (which_type=='regular_weekly' || which_type=='regular_monthly' || which_type=='regular_yearly') {
    sql="insert into regular_chores_rec (reg_chore_id, conducted_on) values (" + task + ", '" + d + "'); ";
    sql += "update regular_chores_idx set last_conducted_on='" + d + "' where reg_chore_id = " + task + ";";
  } else if (which_type=='irregular_weekly' || which_type=='irregular_monthly' || which_type=='irregular_yearly') {
    sql="update irregular_chores_idx set conducted_on='" + d + "' where irr_chore_id = " + task + ";";
  }

  cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
  document.in.commands.value=cmd_str;
}

function register_new_regular_task() {
  var p=parseInt(document.in.period_for_regular_task.value);
  var n=document.in.name_of_new_regular_task.value;
  if (isNaN(p) || p < 1) {
    alert('周期をちゃんと指定してね');
  } else if (n == '') {
    alert('定期タスク名を入力してね');
  } else {
    var sql="insert into regular_chores_idx (validity, period, what_to_do) values (1, " + p.toString() + ", '" + n + "');";
    cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
    document.in.commands.value=cmd_str;
  }
}

function register_new_irregular_task() {
  var d=document.in.deadline_for_irregular_task.value;
  var n=document.in.name_of_new_irregular_task.value;
  if (isNaN(Date.parse(d))) {
    alert('日付の形式が変ですよ');
  } else if (n == '') {
    alert('非定期タスク名を入力してね');
  } else {
    var sql="insert into irregular_chores_idx (validity, to_be_done_by, what_to_do) values (1, '" + d + "', '" + n + "');";
    cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
    document.in.commands.value=cmd_str;
  }
}

function change_period() {
  var task_types=document.in.finished_task_type;
  var which_type;
  for (var i=0; i<task_types.length; i++) {
    if (task_types[i].checked) {
      which_type=task_types[i].value;
      break;
    }
  }
  if (which_type=='regular_weekly' || which_type=='regular_monthly' || which_type=='regular_yearly') {
    var p=parseInt(document.in.new_period_for_regular_task.value);
    if (isNaN(p) || p < 1) {
      alert('新しい周期をちゃんと指定してね');
    } else {
      var op_list=document.getElementById(which_type + '_tasks');
      var task=op_list.options[op_list.selectedIndex].value;
      var sql="update regular_chores_idx set period=" + p.toString() + " where reg_chore_id=" + task + ";";
      cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
      document.in.commands.value=cmd_str;
    }
  } else {
    alert('定期タスクを指定してね');
  }
}

function change_deadline() {
  var task_types=document.in.finished_task_type;
  var which_type;
  for (var i=0; i<task_types.length; i++) {
    if (task_types[i].checked) {
      which_type=task_types[i].value;
      break;
    }
  }
  if (which_type=='irregular_weekly' || which_type=='irregular_monthly' || which_type=='irregular_yearly') {
    var d=document.in.new_deadline_for_irregular_task.value;
    if (isNaN(Date.parse(d))) {
      alert('新しい締切をちゃんと指定してね');
    } else {
      var op_list=document.getElementById(which_type + '_tasks');
      var task=op_list.options[op_list.selectedIndex].value;
      var sql="update irregular_chores_idx set to_be_done_by='" + d + "' where irr_chore_id=" + task + ";";
      cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
      document.in.commands.value=cmd_str;
    }
  } else {
    alert('非定期タスクを指定してね');
  }
}

var sel_ids=['regular_weekly_tasks', 'regular_monthly_tasks', 'regular_yearly_tasks', 'irregular_weekly_tasks', 'irregular_monthly_tasks', 'irregular_yearly_tasks'];

function reset_op_color(focused_sel_idx) {
  for (var i=0; i<6; i++) {
    if (i!=focused_sel_idx) {
      document.getElementById(sel_ids[i]).selectedIndex=-1;
    }
  }
}

function add_last_command() {
  cmd_str += "./init.sh\n";
  document.in.commands.value=cmd_str;
}

window.onload = function () {
  cmd_str="";
  document.in.reset();
};
