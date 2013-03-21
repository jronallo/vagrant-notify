module Vagrant
  module Notify
    class Plugin < Vagrant.plugin('2')
      name 'vagrant notify'
      description 'Forwards notify-send from guest to host machine'

      action_hook 'start-server-after-boot' do |hook|
        require_relative './action'
        # TODO: This should be generic
        hook.after VagrantPlugins::ProviderVirtualBox::Action::Boot, Vagrant::Notify::Action.action_start_server

        if defined?(Vagrant::LXC)
          # TODO: Require just the boot file once its "require dependencies" are sorted out
          require 'vagrant-lxc/action'
          hook.after Vagrant::LXC::Action::Boot, Vagrant::Notify::Action.action_start_server
        end
      end

      action_hook 'install-command-after-provisioning', :machine_action_provision do |hook|
        hook.after Vagrant::Action::Builtin::Provision, Vagrant::Notify::Action.action_start_server
      end

      action_hook 'stop-server-after-halting' do |hook|
        require_relative './action'
        hook.after Vagrant::Action::Builtin::GracefulHalt, Vagrant::Notify::Action.action_stop_server
      end
    end
  end
end