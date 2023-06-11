# Postmortem
*DevOps* *SysAdmin*

This postmortem is about service outage from 17:18 April 29, 2023 (Africa/Lagos, GMT+1) to 17:40 April 29, 2023 (Africa/Lagos, GMT+1) on an aplication server from which I served a [Laravel](https://laravel.com) application.

The server was returning a 500 (Internal server error) response.

The root cause of the problem is that this application was sharing environment variables with another Laravel application on the same server. The `.env` files on each of the applications contained environment variables necessary to run the app. As environment variables, they are system wide for the entire duration of the script execution. Therefore, the two different applications had a `.env` file with the same variable names but different values and one of them is overwriting the other, in this case the first.

## Timeline

The issue was detected when the application was first deployed to production.

It was detected by me as I was testing the newly deployed app.

Initially, I assumed that maybe the database was incorrectly set to that of the other Laravel app in the .env file because the logs were reflecting that it's not able to write data to the database because of inadequate permission(Here's access control coming to the rescue, because without it, the database of the other Laravel app would have been tampered with).

The misleading investigation/debugging path was trying to fix the issue from the database, although as usual, I didn't tamper with the production app, I just reproduced the error on a new [docker](https://docker.com) container which had the same setup as my application server.

The incident was resolved by namespacing my environment variables as suggested by the phpdotenv package author on [Laracasts](https://laracasts.com/discuss/channels/laravel/multiple-db-connections-problem):
```env
APP_NAME_M="Example"
APP_ENV_M=production
APP_KEY_M=
```

## Corrective and Preventive measures

The web infrastructure can be improved greatly by introducing another server that will serve the second laravel application so that each application will be running on it's own application server. This will improve efficiency by reducing the load on the server.

To prevent this issue or correct it when it happens:
- Add Monitoring on the server with a monitoring service like [Datadog](https://datadoghq.com).
- Use a configuration management tool like [Puppet](https://puppet.com), [Ansible](https://ansible.com) or [Chef](https://chef.io).
