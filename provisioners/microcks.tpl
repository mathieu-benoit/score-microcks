- op: set
  path: services.microcks
  value:
    image: quay.io/microcks/microcks-uber:nightly
    ports:
    - target: 8080
      published: "9090"