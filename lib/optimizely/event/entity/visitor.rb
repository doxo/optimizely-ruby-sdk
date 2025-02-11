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
module Optimizely
  class Visitor
    attr_reader :snapshots, :visitor_id, :attributes
    def initialize(opts = {})
      @snapshots = opts[:snapshots]
      @visitor_id = opts[:visitor_id]
      @attributes = opts[:attributes]
    end

    def as_json
      {
        snapshots: @snapshots,
        visitor_id: @visitor_id,
        attributes: @attributes
      }
    end
  end
end
