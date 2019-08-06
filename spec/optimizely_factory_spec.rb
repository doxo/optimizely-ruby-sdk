# frozen_string_literal: true

#
#    Copyright 2019, Optimizely and contributors
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
#
require 'spec_helper'
require 'optimizely'
require 'optimizely/config_manager/http_project_config_manager'
require 'optimizely/config_manager/static_project_config_manager'
require 'optimizely/exceptions'
require 'optimizely/optimizely_factory'

describe Optimizely::OptimizelyFactory do
  let(:datafile) { OptimizelySpec::VALID_CONFIG_BODY_JSON }
  let(:error_handler) { Optimizely::RaiseErrorHandler.new }
  let(:spy_logger) { spy('logger') }
  let(:user_profile_service) { spy('user_profile_service') }
  let(:event_dispatcher) { Optimizely::EventDispatcher.new }
  let(:notification_center) { Optimizely::NotificationCenter.new(spy_logger, error_handler) }

  describe '.default_instance' do
    it 'should take http config manager' do
      allow(Optimizely::HTTPProjectConfigManager).to receive(:new)

      http_project_config_manager = Optimizely::HTTPProjectConfigManager.new(
        sdk_key: 'sdk_key',
        datafile: datafile,
        logger: spy_logger,
        error_handler: error_handler,
        skip_json_validation: false,
        notification_center: notification_center
      )

      optimizely_instance = Optimizely::OptimizelyFactory.default_instance('sdk_key', datafile)

      expect(optimizely_instance.config_manager). to eq(http_project_config_manager)
    end
  end

  describe '.default_instance_with_manager' do
    it 'should take provided custom config manager' do
      class CustomConfigManager
        def get_config; end
      end

      custom_config_manager = CustomConfigManager.new
      optimizely_instance = Optimizely::OptimizelyFactory.default_instance_with_config_manager(custom_config_manager)
      expect(optimizely_instance.config_manager). to eq(custom_config_manager)
    end
  end

  describe '.custom_instance' do
    it 'should take http config manager when sdk key is given' do
      allow(Optimizely::HTTPProjectConfigManager).to receive(:new)
      http_project_config_manager = Optimizely::HTTPProjectConfigManager.new(
        sdk_key: 'sdk_key',
        datafile: datafile,
        logger: spy_logger,
        error_handler: error_handler,
        skip_json_validation: false,
        notification_center: notification_center
      )

      optimizely_instance = Optimizely::OptimizelyFactory.custom_instance(
        'sdk_key',
        datafile,
        event_dispatcher,
        spy_logger,
        error_handler,
        false,
        user_profile_service,
        nil,
        notification_center
      )
      expect(optimizely_instance.config_manager). to eq(http_project_config_manager)
    end

    it 'should take event processor when flush interval and batch size are set' do
      allow(Optimizely::HTTPProjectConfigManager).to receive(:new)

      event_processor = BatchEventProcessor.new(
        event_dispatcher: event_dispatcher,
        batch_size: @max_event_batch_size,
        flush_interval: @max_event_flush_interval,
        notification_center: notification_center
      )

      optimizely_instance = Optimizely::OptimizelyFactory.custom_instance(
        'sdk_key',
        datafile,
        event_dispatcher,
        spy_logger,
        error_handler,
        false,
        user_profile_service,
        nil,
        notification_center
      )
      expect(optimizely_instance.config_manager). to eq(http_project_config_manager)
    end
  end
end
