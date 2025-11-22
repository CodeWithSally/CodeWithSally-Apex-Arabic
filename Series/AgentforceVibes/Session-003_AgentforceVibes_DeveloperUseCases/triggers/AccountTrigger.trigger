trigger AccountTrigger on Account (before insert, before update) {
    for (Account acc : Trigger.new) {
        if (acc.AnnualRevenue > 1000000) {
            acc.Description = 'High-value customer';
        }
        if (acc.Industry == 'Finance') {
            acc.Rating = 'Hot';
        }
    }
}