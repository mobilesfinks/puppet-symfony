class { 'symfony':
    withEnvironment     => false,
    withMySql           => false,
    withNodejs          => false,
    withAllPhars        => false,
    withComposerInstall => false,
    withPhpMyAdmin      => false,
    withRabbitMQ        => false,
    withSelenium        => false,
    withRedis           => false,
    withDEVSettings     => false
}