Access to documentation:https://github.com/microsoft/azureloadtest

PG: John Stallo

Private preview: Feb 2021

JMeter examples: https://github.com/QASymphony/jmeter-sample/blob/master/Users.jmx

Hey documentation https://github.com/rakyll/hey

## Metrics queries:

### KQL Queries


- Function App Instance over Time Query
```
let grainTime = 30sec;

traces

| where timestamp >= ago(24h)
| summarize ['rate/minute'] = dcount(cloud_RoleInstance) by bin(timestamp, grainTime)
| order by timestamp desc
| render timechart
```
- Function App Instance using Specific Time Interval
```
let max_t = <start time here>;
let min_t = <min time here>;
requests
| where timestamp between(min_t..max_t)
| summarize Count_Function_App_Instances=dcount(cloud_RoleInstance) by bin(timestamp, 30s)
| render timechart
```
- Unique Function Instances
```
let grainTime = 30sec;
traces
| where timestamp >= ago(24h)
| distinct cloud_RoleInstance
```
- Requests Per Second
```
requests
| where timestamp > ago(1h)
| summarize totalCount=sum(itemCount) by bin(timestamp, 1s)
| render timechart
```