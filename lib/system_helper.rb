def open_url(url)
  run("open #{url}")
end

def run(command)
  system(command)
  ExecutionStatus.new($?.exitstatus)
end

class ExecutionStatus

  attr_reader :code

  def initialize(exit_code)
    @code = exit_code
  end

  def success?
    @code == 0
  end

  def failed?
    !success?
  end

end