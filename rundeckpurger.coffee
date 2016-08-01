#!/usr/bin/env coffee

request = require "request"
async = require "async"

throw new Error ("rundeck URL is required !") if !process.env.URL?
throw new Error ("rundeck APIKEY is required !") if !process.env.APIKEY?
throw new Error ("rundeck PROJECT is required !") if !process.env.PROJECT?

epochago = (new Date()).getTime() - (parseInt(process.env.DAYSAGO or 7) * 86400 * 1000)

listurl = "#{process.env.URL}/api/14/project/#{process.env.PROJECT}/history"
delurl = "#{process.env.URL}/api/12/executions/delete"
listqs = {authtoken:process.env.APIKEY,format:"json",end:epochago}


delCargo = async.cargo (ids,cb)->
	console.log "erasing #{ids.join(',')}"
	request {method:"POST", url:delurl, qs:{authtoken:process.env.APIKEY,format:"json",ids:ids.join(",")}}, (er,ro,rb)->
		if er?
			console.log "\tunable to delete ", ids.join(",")
		cb()
,20

async.forever (next)->
	request {method:"GET", url:listurl, qs:listqs, json:true}, (er,ro,rb)->
		if rb?.events? and Array.isArray(rb.events) and rb.events.length > 0
			for ev in rb.events
				delCargo.push(ev.execution.id)
			delCargo.drain = ->
				if delCargo.length() + delCargo.running() is 0
					console.log "\tbatch done"
					next(false)
			delCargo.drain()
		else
			if rb.error?
				console.log "Error in response : #{rb.message}"
			else if Array.isArray(rb.events) and rb.events.length is 0
				console.log "No events found"
			else
				console.log "Unable to parse response", rb
			next(true)
,(err)->
	process.exit 0