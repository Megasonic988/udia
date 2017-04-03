###############################################################################
# The contents of this file are subject to the Common Public Attribution
# License Version 1.0. (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# https://raw.githubusercontent.com/udia-software/udia/master/LICENSE.
# The License is based on the Mozilla Public License Version 1.1, but
# Sections 14 and 15 have been added to cover use of software over a computer
# network and provide for limited attribution for the Original Developer.
# In addition, Exhibit A has been modified to be consistent with Exhibit B.
#
# Software distributed under the License is distributed on an "AS IS" basis,
# WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
# the specific language governing rights and limitations under the License.
#
# The Original Code is UDIA.
#
# The Original Developer is the Initial Developer.  The Initial Developer of
# the Original Code is Udia Software Incorporated.
#
# All portions of the code written by UDIA are Copyright (c) 2016-2017
# Udia Software Incorporated. All Rights Reserved.
###############################################################################
use Mix.Config

config :udia,
  ecto_repos: [Udia.Repo]

config :udia, Udia.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5DVQC7qZ+N1uuJw8Stt+W2MzteZRo73h8CaODP3VRh5GAzO2JnvLievrbMb/sKNq",
  render_errors: [view: Udia.Web.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Udia.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Udia",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Udia.GuardianSerializer

import_config "#{Mix.env}.exs"
