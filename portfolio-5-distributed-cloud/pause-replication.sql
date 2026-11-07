ALTER SUBSCRIPTION p5_subscription DISABLE;

SELECT subname, subenabled
FROM pg_subscription
WHERE subname = 'p5_subscription';
