-- Power DNS recursor script for modifying the behaviour of DNS
-- responses. The functions here are tested with Power DNS 3.7 and it
-- may not work with older versions.


-- Load domains into a table
function load_domains ()
   -- Load domains if they aren't already loaded
   if not domains then
      io.input('/var/local/blacklist')
      -- Polulate the global variable domains with all domains listed in
      -- the blacklist
      domains = {}
      for d in io.lines() do
         domains[d] = true
      end
   end
end

-- Load domains to database
function load_domains_to_sql (db)
   io.input('/var/local/blacklist')
   -- Read domains from the file and insert them into the domains
   -- table
   for d in io.lines() do
      db:execute(string.format("INSERT INTO domain VALUES ('%s')", d))
   end
end


-- Return a connection to the SQLite database
function db_conn ()
   -- Initialise the database if global variable `db' is nil
   if not db then
      print("Initialising the database")
      db_driver = require "luasql.sqlite3"
      env = db_driver.sqlite3()

      db = env:connect(":memory:")

      -- Create the tables
      db:execute([[
CREATE TABLE domain (
  name TEXT PRIMARY KEY NOT NULL
);]])
      print("Loading domains into the database")
      load_domains_to_sql(db)
   end
   return db
end


function ipfilter (remoteip)
   return -1, {}
end


function preresolve (remoteip, domain, qtype)
   --[[
   db = db_conn()
   stmt = string.format("SELECT name FROM domain WHERE name='%s'",
                        -- Strip away the '.' at the end
                        string.sub(domain, 1, -2))
   cur = db:execute(stmt)
   if cur:fetch() then
      return 0, { {qtype=pdns.A, content="127.0.0.1"} }
   end
   ]]--
   -- Load domains
   load_domains()
   if domains[string.sub(domain, 1, -2)] then
      -- Domain needs to be blocked
      return 0, { {qtype=pdns.A, content="127.0.0.1"} }
   end
   -- Pass by default
   return -1, {}
end

--[[
function postresolve ( remoteip, domain, qtype, records, origrcode )
end

function nxdomain ( remoteip, domain, qtype )
end

function nodata ( remoteip, domain, qtype, records )
end

function preoutquery ( remoteip, domain, qtype )
end
]]--
