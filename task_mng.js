var cmd_str="";

function record_finished_task() {
  var d=document.in.date_when_task_finished.value;
  //console.log(d);
  var task_types=document.in.finished_task_type;
  var which_type;
  for (var i=0; i<task_types.length; i++) {
    if (task_types[i].checked) {
      which_type=task_types[i].value;
      break;
    }
  }
  //console.log(which_type);
  var op_list=document.getElementById(which_type + '_tasks');
  var task=op_list.options[op_list.selectedIndex].value;
  //console.log(task);
  //var s=d + "," + which_type + "," + task +"\n";
  //document.in.commands.value += s;
  var sql="";
  if (which_type=='regular_weekly_tasks' ||
    which_type=='regular_monthly_tasks' ||
    which_type=='regular_yearly_tasks') {
    sql="insert into regular_chores_rec (reg_chore_id, conducted_on) values (" + task + ", '" + d + "'); ";
    sql += "update regular_chores_idx set last_conducted_on='" + d + "' where reg_chore_id = " + task + ";";
  } else if (which_type=='irregular_weekly_tasks' ||
    which_type=='irregular_monthly_tasks' ||
    which_type=='irregular_yearly_tasks') {
    sql="update irregular_chores_idx set conducted_on='" + d + "' where irr_chore_id = " + task + ";";
  }
  //console.log(sql);
  cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
  document.in.commands.value=cmd_str;
}

function register_new_regular_task() {
  var sql="insert into regular_chores_idx (validity, period, what_to_do) values (1, " + parseInt(document.in.period_for_regular_task.value).toString() + ", '" + document.in.name_of_new_regular_task.value + "');";
  cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
  document.in.commands.value=cmd_str;
}

function register_new_irregular_task() {
  var sql="insert into irregular_chores_idx (validity, to_be_done_by, what_to_do) values (1, '" + document.in.deadline_for_irregular_task.value + "', '" + document.in.name_of_new_irregular_task.value + "');";
  cmd_str += "sqlite3 chores.db \"" + sql + "\"\n";
  document.in.commands.value=cmd_str;
}

function add_last_command() {
  cmd_str += "./init.sh\n";
  document.in.commands.value=cmd_str;
}

window.onload = function () {
//  //cmd_str="sqlite3 chores.db <<'CHORES'\n";
  cmd_str="";
  document.in.reset();
};
