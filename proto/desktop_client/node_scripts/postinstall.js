var platform = require('os').platform();
var exec = require('child_process').exec;

if (platform === 'win32' || platform === 'win64')
{
    exec('copy .gulpconfig.json.example .gulpconfig.json && gulp install');
}
else
{
    exec('cp .gulpconfig.json.example .gulpconfig.json && gulp install');
}
