class { 'symfony':
    withEnvironment     => true,
    withMySql           => true,
    withNodejs          => true,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => false,
    withSelenium        => false,
    withRedis           => false,
    withDEVSettings     => false
}