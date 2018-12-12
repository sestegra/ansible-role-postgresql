# Ansible Role & Helper for PostgresSQL

## Getting Started

Use following command to get help
```
$ make
```

See example in `hosts` file and `playbooks` directory.

### Prerequisites

Hosts should be bootstrapped with ANSIBLE_USER.
ANSIBLE_USER needs:
  - 'CD' public SSH shared key installed
  - sudo without password priviliges configured

## TODO
  - [ ] Support more postgresql_user parameters
  - [ ] Support more postgresql_db parameters
  - [ ] Test with CentOS 8

## Tests

Following tests have been successfully executed:
  - CentOS 6 and 7 with PostgresSQL 10.6
  - CentOS 6 and 7 with PostgresSQL 11.1

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
