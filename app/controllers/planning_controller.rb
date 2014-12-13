class PlanningController < ApplicationController
  def senddtp
    params.permit(:result)
    render text: params[:result]
  end

  def prepare_data
    puts 'data_prepared'
  end

  def auto_solve
    #Ok, let's wait end of previous process
    while File.exist?('lib/planer/lock')
      sleep(1.0/10.0)
    end

    File.open("lib/planer/lock", 'w') {|f| f.puts("locked")}
    data = prepare_data
    #TODO replace with really unic string
    cur_time = Time.now.to_i.to_s
    outfile = 'lib/planer/_input/' + cur_time + '_task.pddl'
    File.open(outfile, 'w') {|f| f.puts(data)}
    #TODO NEED LINUX SERVER OR CHANGE IT
    res = `cd lib/planer/ && ./plan _input/domain_new.pddl _input/p01_new.pddl _output/#{cur_time}_task.pddl`
    #TODO maybe need .best solution?
    result = File.open("lib/planer/_output/#{cur_time}_task.pddl", 'r') {|f| f.read}

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

    render json: result.to_json
  end
end
