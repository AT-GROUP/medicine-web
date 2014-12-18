class PlanningController < ApplicationController
  def cap_solve
    ans = 0.0
    params[:car].sort[0..params[:total_victim] - 1].each do |car|
      ans += car
    end
    surgery_list = params[:surgery].sort[0..params[:surgery_victim] - 1].each do |surg|
      ans += surg
    end
    neuro_list = params[:neuro].sort[0..params[:neuro_victim] - 1].each do |neur|
      ans += neur
    end
    reanimation_list = params[:reanimation].sort[0..params[:reanimation_victim] - 1].each do |rean|
      ans += rean
    end
    burn_list = [:burn].sort[0..params[:burn_victim] - 1].each do |brn|
      ans += brn
    end
    render text: ans.to_s
  end

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
