module RakeTerraform
  # == RakeTerraform::TerraformCmd
  #
  # Helper module for running wrapping terraform calls
  #
  # TODO: refactor public methods to take splat arguments and write private
  #       command builder methods
  #
  module TerraformCmd
    # perform a 'terraform get'
    def tf_get(update = false)
      cmd = 'terraform get'
      update && cmd << ' -update'
      system(cmd)
    end

    # perform a 'terraform plan'
    #
    # access_key and secret_key are optional as terraform and it's underlying
    # library have supported the standard AWS_PROFILE env var for a while
    #
    def tf_plan(access_key = nil, secret_key = nil,
                output_file = nil, state_file = nil, module_depth = 2)
      cmd = 'terraform plan'
      cmd << " -module-depth #{module_depth}"
      state_file && cmd << " -state #{state_file}"
      if access_key && secret_key
        # TODO: additional escaped quotes required?
        cmd << " -var access_key=\"#{access_key}\""
        cmd << " -var secret_key=\"#{secret_key}\""
      elsif access_key || secret_key
        raise ArgumentError, 'Only one of access_key or secret_key given'
      end
      output_file && cmd << " -out #{output_file}"
      system(cmd)
    end

    # perform a 'terraform show'
    #
    def tf_show(plan_file, module_depth = 2)
      cmd = 'terraform show'
      cmd << " -module-depth #{module_depth}"
      cmd << " #{plan_file}"
      system(cmd)
    end

    # perform a 'terraform apply'
    #
    def tf_apply(plan_file, state_file = nil)
      cmd = 'terraform apply'
      state_file && cmd << " -state #{state_file}"
      cmd << " #{plan_file}"
      system(cmd)
    end
  end
end
