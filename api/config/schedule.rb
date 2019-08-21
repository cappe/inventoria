set :job_template, "/bin/sh -l -c ':job'"

set :output, {
  error: '/usr/src/log/error.log',
  standard: '/usr/src/log/standard.log'
}

if @environment == 'production'
  every 1.day, at: '4:30 am' do
    rake "app:orders:process_pending"
  end

  every 15.minutes do
    rake "app:orders:process_deliver_now"
  end
end
