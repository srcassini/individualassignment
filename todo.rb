#Variables
$todo_list = []
$pValue = 0
$MAX_P = 9

#Program defs
def setup
  puts 'Todo List v0.06.1'
end

def finished()
  puts "Bye..."
end

def parse_command(line)
  letter = line[0]
  stripped = line[1..-1].strip
  case letter
  when 'A'
    add_todo(stripped)
  when 'D'
    del_todo(stripped)
  when 'P'
    set_priority(stripped)
  when '+'
    increase_priority(stripped)
  when '='
    list_p_or_above(stripped)
  when 'L'
    list_todo(stripped)
  else
    puts "Commands: Q-uit A-dd L-ist H-elp"
  end
end

#List content defs
def add_todo(todo)
  if todo == ''
    puts "  :| Nothing to Add - Try \'A todo description\'"
  else
    if $todo_list.length == 0
      $todo_list.push [$pValue, todo]
    else
      insertAt = $todo_list.length
      index = 0
      loop do
        checkDouble = $todo_list[index]
        if insertAt == 0 || index == $todo_list.length
          $todo_list.insert(insertAt, [$pValue, todo])
          break
        elsif get_existing_todo(todo, checkDouble)
          puts "  :| This Todo already exists!"
          break
        elsif $pValue > $todo_list[index][0]
          if index == $todo_list.length
            $todo_list.insert(insertAt, [$pValue, todo])
            break
          else
            insertAt -= 1
            index += 1
          end
        else
          index += 1
        end
      end
    end
  end
end

def list_todo(index)
  if $todo_list.length == 0
    puts "  :| No ToDos exist (yet)"
  elsif index == ''
    $todo_list.each.with_index do |todo, index|
      puts "  #{index} (#{todo[0]}) #{todo[1]}"
    end
  else
    list_todo_at_index(index)
  end
end

def list_todo_at_index(index)
  index = index.to_i

  if index > $todo_list.length
    puts "  :| No matching Todos"
  else
    puts " #{index} (#{$todo_list[index][0]}) #{$todo_list[index][1]}"
  end
end

def list_p_or_above(thresholdP)
  outputCount = 0
  $todo_list.each.with_index do |todo, index|
    if todo[0] < thresholdP.to_i
      next
    else
      puts "  #{index} (#{todo[0]}) #{todo[1]}"
      outputCount += 1
    end
  end
  if outputCount == 0
    puts "  :| Priority value is out of range!"
  end
end

def del_todo(index)
  index = index.to_i
  if index > $todo_list.length
    puts "  :| No matching Todos"
  else
    $todo_list.delete_at(index)
  end
end

def get_existing_todo(todo, checkDouble)
  if todo == checkDouble[1]
    return true
  elsif todo != checkDouble[1]
    return false
  end
end

#Priority defs
def set_priority(priority)
  if priority == ''
    puts "  Priority is currently #{$pValue}"
  elsif (priority.to_i < 0) || (priority.to_i > $MAX_P)
    puts "  :| Priority must be 0 to 9"
  else
    $pValue = priority.to_i
  end
end

def increase_priority(index)
  index = index.to_i
  if index > $todo_list.length - 1
    puts "  :| No matching Todos"
  elsif $todo_list[index][0] == $MAX_P
    puts "  :| Priority is at maxiumum."
  else
    $todo_list[index][0] += 1
  end
end

# The main command loop
def main_loop()
  setup()
  finished = false
  while !finished
    print ":) "
    line = gets.chomp
    if line == 'Q'
      finished = true
    else
      parse_command(line)
    end
  end
  exit
end

#Initialising the program
main_loop()
