class PlanningController < ApplicationController
  def senddtp
    params.permit(:result)
    solve_res = auto_solve(params[:result])
    render text: solve_res.to_s
  end

  def prepare_in_data(raw_data)
    #TODO
    puts 'data_prepared'
    return raw_data
  end

  def prepare_out_data(raw_data)
    #TODO
    puts 'data_prepared'
    return raw_data
  end

  def auto_solve(data)
    #Ok, let's wait end of previous process
    while File.exist?('lib/planer/lock')
      sleep(1.0/10.0)
    end

    File.open("lib/planer/lock", 'w') {|f| f.puts("locked")}
    data = prepare_in_data(data)
    #TODO replace with really unic string
    cur_time = Time.now.to_i.to_s
    outfile = 'lib/planer/_input/' + cur_time + '_task.pddl'
    File.open(outfile, 'w') {|f| f.puts(data)}
    #TODO NEED LINUX SERVER OR CHANGE IT
    res = `cd lib/planer/ && ./plan _input/domain_new.pddl _input/p01_new.pddl _output/#{cur_time}_task.pddl`
    #TODO maybe need .best solution?
    result = File.open("lib/planer/_output/#{cur_time}_task.pddl", 'r') {|f| f.read}
    #TODO transform data
    result = prepare_out_data(result)

    #clear block
    #delete task
    File.delete("lib/planer/_input/#{cur_time}_task.pddl")
    #delete all results
    File.delete("lib/planer/_output/#{cur_time}_task.pddl")
    File.delete("lib/planer/_output/#{cur_time}_task.pddl.best")
    File.delete("lib/planer/_output/#{cur_time}_task.pddl.times")
    #delete common files
    File.delete("lib/planer/output")
    File.delete("lib/planer/output.sas")
    File.delete("lib/planer/variables.groups")
    File.delete("lib/planer/all.groups")

    #unlock planer
    File.delete("lib/planer/lock")

    return result
  end
end
