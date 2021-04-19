
insert into plugin ( id, name, icon, update_time) values ('fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '001'));

INSERT INTO rule_group (`name`, `description`, `level`, `plugin_id`, `flag`) VALUES ('AWS 等保预检', '等保合规检查（全称为等级保护合规检查）为您提供了全面覆盖通信网络、区域边界、计算环境和管理中心的网络安全检查。', '等保三级', 'fit2cloud-aws-plugin', 1);
INSERT INTO rule_group (`name`, `description`, `level`, `plugin_id`, `flag`) VALUES ('AWS CIS合规检查', 'CIS（Center for Internet Security）合规检查能力，为您动态且持续地监控您保有在云上的资源是否符合 CIS Control 网络安全架构要求。', '高风险', 'fit2cloud-aws-plugin', 1);
INSERT INTO rule_group (`name`, `description`, `level`, `plugin_id`, `flag`) VALUES ('AWS S3合规基线', 'S3 合规检查为您提供全方位的对象存储资源检查功能。', '高风险', 'fit2cloud-aws-plugin', 1);


INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('07eb95ef-6d78-4b9a-8555-a42b6a16de99', 'AWS ELB SSL 黑名单扫描', 1, 'HighRisk', 'AWS  测您账号下ELB SSL 黑名单扫描，在白名单视为“合规”，黑名单视为“不合规”', 'policies:\n    # 测您账号下ELB SSL 黑名单扫描，在白名单视为“合规”，黑名单视为“不合规”\n    - name: aws-elb-ssl-whitelist\n      resource: aws.elb\n      filters:\n        - type: ssl-policy\n          blacklist:\n            - Protocol-TLSv1\n            - Protocol-TLSv1.1\n            - Protocol-TLSv1.2', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('0be7f5d4-766c-4b2b-910d-bec0f3aac977', 'AWS ELB实例使用扫描', 1, 'HighRisk', 'AWS  检测您账号下弹性负载均衡器是否使用，使用视为“合规”，否则视为“不合规”', 'policies:\n    # 检测您账号下弹性负载均衡器是否使用，使用视为“合规”，否则视为“不合规”\n    - name: aws-elb--unused\n      resource: aws.elb\n      filters:\n        - \"tag:maid_status\": absent\n        - Instances: []', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('0dda84c1-794b-4977-bb66-6f12695c6c51', 'AWS RDS实例公网访问扫描', 1, 'HighRisk', 'AWS  检测您账号下RDS实例不允许任意来源公网访问，视为“合规”，否则视为“不合规”', 'policies:\n    # 检测您账号下RDS实例不允许任意来源公网访问，视为“合规”，否则视为“不合规”。\n    - name: aws-rds-publicly-accessible\n      resource: aws.rds\n      filters:\n        - PubliclyAccessible: ${{value}}', '[{\"key\":\"value\",\"name\":\"启用公网访问\",\"defaultValue\":\"true\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('35b5c651-5bd6-44b8-85ee-ae6adfa42dc3', 'AWS EIP连接扫描', 1, 'HighRisk', 'AWS  检测您账号下的弹性IP实例是否已连接，是视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的弹性IP实例是否已连接，是视为“合规”，否则视为“不合规”\n  - name: aws-unused-network-addr\n    resource: aws.network-addr\n    filters:\n      - NetworkInterfaceId: absent\n      - AssociationId: absent', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', 'AWS SecurityGroup高危安全组扫描', 1, 'HighRisk', 'AWS  检测安全组是否开启风险端口，未开启视为“合规”，否则属于“不合规”', 'policies:\n  #扫描开放以下高危端口的安全组：\n  #(20,21,22,25,80,773,765,1733,1737,3306,3389,7333,5732,5500)\n  - name: aws-security-group\n    resource: aws.security-group\n    description: |\n      Add Filter all security groups, filter ports\n      [20,21,22,25,80,773,765,1733,1737,3306,3389,7333,5732,5500]\n      on 0.0.0.0/0 or\n      [20,21,22,25,80,773,765, 1733,1737,3306,3389,7333,5732,5500]\n      on ::/0 (IPv6)\n    filters:\n        - or:\n            - type: ingress\n              IpProtocol: \"-1\"\n              Ports: ${{ipv4_port}}\n              Cidr: \"0.0.0.0/0\"\n            - type: ingress\n              IpProtocol: \"-1\"\n              Ports: ${{ipv6_port}}\n              Cidr: \"::/0\"', '[{\"key\":\"ipv4_port\",\"name\":\"ipv4端口\",\"defaultValue\":\"[20,21,22,25,80,773,765, 1733,1737,3306,3389,7333,5732,5500]\",\"required\":true},{\"key\":\"ipv6_port\",\"name\":\"ipv6端口\",\"defaultValue\":\"[20,21,22,25,80,773,765, 1733,1737,3306,3389,7333,5732,5500]\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('5c47228c-7fe1-484b-a5b6-7c1968074f69', 'AWS EC2运行时间扫描', 1, 'LowRisk', 'AWS  检测您账号下的EC2是否运行时间达到n天，否视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的EC2是否运行时间达到n天，否视为“合规”，否则视为“不合规”\n  - name: aws-ec2-old-instances\n    resource: aws.ec2\n    filters:\n      - “State.Name”: running\n      - type: instance-age\n        days: ${{day}}', '[{\"key\":\"day\",\"name\":\"运行天数\",\"defaultValue\":\"90\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('a6c513a8-8e18-4341-94b7-b6588fdcd1f4', 'AWS RDS实例加密扫描', 1, 'HighRisk', 'AWS  检测您账号下RDS实例是否加密，加密视为“合规”，否则视为“不合规”', 'policies:\n    # 检测您账号下RDS实例是否加密，加密视为“合规”，否则视为“不合规”\n    - name: aws-rds-unencrypted\n      resource: aws.rds\n      filters:\n        - StorageEncrypted: ${{value}}', '[{\"key\":\"value\",\"name\":\"是否加密\",\"defaultValue\":\"false\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('a90a1ba1-b392-4bf2-af31-20ecbefe5811', 'AWS EBS加密扫描', 1, 'HighRisk', 'AWS  检测您账号下的EBS是否加密，加密视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的EBS是否加密，加密视为“合规”，否则视为“不合规”\n  - name: aws-unencrypted-ebs\n    resource: aws.ebs\n    filters:\n      - Encrypted: ${{value}}', '[{\"key\":\"value\",\"name\":\"是否加密\",\"defaultValue\":\"false\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('b1491f69-f3b8-40ae-9659-4242dbc30a0b', 'AWS RDS实例是否使用扫描', 1, 'HighRisk', 'AWS  检测您账号下RDS实例是否使用，使用视为“合规”，否则视为“不合规”', 'policies:\n    # 检测您账号下RDS实例是否使用，使用视为“合规”，否则视为“不合规”\n    - name: aws-rds-unused-databases\n      resource: aws.rds\n      filters:\n        - \"tag:c7n_rds_unused\": absent\n        - type: value\n          value_type: age\n          key: InstanceCreateTime\n          value: ${{day}}\n          op: greater-than', '[{\"key\":\"day\",\"name\":\"天（大于）\",\"defaultValue\":\"21\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('b57cbdba-b4d7-4da7-84db-25b9f2d5324b', 'AWS EC2标签规范扫描', 1, 'HighRisk', 'AWS  检测您账号下的EC2实例是否符合标签规范（非ASG），符合视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的EC2实例是否符合标签规范（非ASG），符合视为“合规”，否则视为“不合规”\n  - name: aws-ec2-tag\n    resource: aws.ec2\n    comment: |\n      Find all (non-ASG) instances that are not conformant\n      to tagging policies.\n    filters:\n      - \"tag:aws:autoscaling:groupName\": absent\n      - \"tag:c7n_status\": absent\n      - or:\n          - \"tag:Owner\": ${{Owner}}\n          - \"tag:CostCenter\": ${{CostCenter}}\n          - \"tag:Project\": ${{Project}}', '[{\"key\":\"Owner\",\"name\":\"tag:Owner\",\"defaultValue\":\"absent\",\"required\":true},{\"key\":\"CostCenter\",\"name\":\"tag:CostCenter\",\"defaultValue\":\"absent\",\"required\":true},{\"key\":\"Project\",\"name\":\"tag:Project\",\"defaultValue\":\"absent\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('bd1a0479-ef54-4208-a520-50caf6acfe87', 'AWS EC2实例关机状态扫描', 1, 'HighRisk', 'AWS  检测您账号下的EC2实例是关机，开机视为“合规”，关机视为“不合规”', 'policies:\n  # 检测您账号下的EC2实例是关机，开机视为“合规”，关机视为“不合规”\n  - name: aws-ec2-mark-stopped-instance\n    resource: aws.ec2\n    filters:\n      - \"tag:c7n_stopped_instance\": absent\n      - \"State.Name\": ${{state}}', '[{\"key\":\"state\",\"name\":\"实例状态\",\"defaultValue\":\"stopped\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('befc89d7-1811-404a-9226-f8ecc22820e0', 'AWS EBS连接扫描', 1, 'HighRisk', 'AWS  检测您账号下的EBS是否连接，连接视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的EBS是否连接，连接视为“合规”，否则视为“不合规”\n  - name: aws-unattached-ebs\n    resource: aws.ebs\n    filters:\n      - Attachments: []\n      - \"tag:maid_status\": absent', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', 'AWS S3全局访问扫描', 1, 'HighRisk', 'AWS  检测您账号下的S3是否允许在其ACL中进行全局访问存储桶，不允许视为“合规”，否则视为“不合规”', 'policies:\n\n    - name: s3-global-access\n      resource: aws.s3\n      filters:\n        - type: global-grants', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', 'AWS S3公开读写访问权限扫描', 1, 'HighRisk', 'AWS  查看您的S3存储桶是否不允许公开读写访问权限。如允许则该存储桶不合规', 'policies:\n    # 查看您的S3存储桶是否不允许公开读写访问权限。如允许则该存储桶不合规\n    - name: s3-public-acls\n      resource: aws.s3\n      filters:\n        - type: check-public-block\n          BlockPublicAcls: false\n          BlockPublicPolicy: false', '[]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');
INSERT INTO `rule` (`id`, `name`, `status`, `severity`, `description`, `script`, `parameter`, `plugin_id`, `plugin_name`, `plugin_icon`, `last_modified`, `flag`, `scan_type`) VALUES ('fa5e89e3-417d-4296-9d17-ca51ed914be5', 'AWS EC2 CPU使用率扫描', 1, 'LowRisk', 'AWS  检测您账号下的EC2是否CPU使用率在x天内低于y，否视为“合规”，否则视为“不合规”', 'policies:\n  # 检测您账号下的EC2是否CPU使用率在x天内低于y，否视为“合规”，否则视为“不合规”\n  - name: aws-ec2-underutilized\n    resource: aws.ec2\n    filters:\n      - type: metrics\n        name: CPUUtilization\n        days: ${{day}}\n        period: 86400  # 扫描周期(86400s为一天)\n        statistics: Average\n        value: ${{used}}\n        op: less-than', '[{\"key\":\"day\",\"name\":\"n天(cpu平均值小于x)\",\"defaultValue\":\"7\",\"required\":true},{\"key\":\"used\",\"name\":\"cpu平均值小于x(n天)\",\"defaultValue\":\"30\",\"required\":true}]', 'fit2cloud-aws-plugin', 'AWS 亚马逊云', 'aws.png', concat(unix_timestamp(now()), '004'), 1, 'custodian');


INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('fa5e89e3-417d-4296-9d17-ca51ed914be5', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('5c47228c-7fe1-484b-a5b6-7c1968074f69', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('befc89d7-1811-404a-9226-f8ecc22820e0', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('bd1a0479-ef54-4208-a520-50caf6acfe87', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('0be7f5d4-766c-4b2b-910d-bec0f3aac977', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('07eb95ef-6d78-4b9a-8555-a42b6a16de99', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('b1491f69-f3b8-40ae-9659-4242dbc30a0b', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('35b5c651-5bd6-44b8-85ee-ae6adfa42dc3', 'cost');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('a90a1ba1-b392-4bf2-af31-20ecbefe5811', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('b57cbdba-b4d7-4da7-84db-25b9f2d5324b', 'tagging');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('a6c513a8-8e18-4341-94b7-b6588fdcd1f4', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('0dda84c1-794b-4977-bb66-6f12695c6c51', 'safety');
INSERT INTO `rule_tag_mapping` (`rule_id`, `tag_key`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', 'safety');


INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('35b5c651-5bd6-44b8-85ee-ae6adfa42dc3', '2');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', '10');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', '13');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', '10');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', '13');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('a90a1ba1-b392-4bf2-af31-20ecbefe5811', '96');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('a6c513a8-8e18-4341-94b7-b6588fdcd1f4', '96');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('0dda84c1-794b-4977-bb66-6f12695c6c51', '97');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '9');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '46');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '92');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '93');
INSERT INTO `rule_inspection_report_mapping` (`rule_id`, `report_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '95');


INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('befc89d7-1811-404a-9226-f8ecc22820e0', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('07eb95ef-6d78-4b9a-8555-a42b6a16de99', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('a90a1ba1-b392-4bf2-af31-20ecbefe5811', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('a6c513a8-8e18-4341-94b7-b6588fdcd1f4', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('0dda84c1-794b-4977-bb66-6f12695c6c51', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '10');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('fa5e89e3-417d-4296-9d17-ca51ed914be5', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('5c47228c-7fe1-484b-a5b6-7c1968074f69', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('befc89d7-1811-404a-9226-f8ecc22820e0', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('bd1a0479-ef54-4208-a520-50caf6acfe87', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('0be7f5d4-766c-4b2b-910d-bec0f3aac977', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('07eb95ef-6d78-4b9a-8555-a42b6a16de99', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('b1491f69-f3b8-40ae-9659-4242dbc30a0b', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('a90a1ba1-b392-4bf2-af31-20ecbefe5811', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('b57cbdba-b4d7-4da7-84db-25b9f2d5324b', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('43a1556b-5417-4efb-88fc-33e8eeb68f71', '11');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('d0f3f4b0-000a-4407-85ee-ed4a2f9dac44', '12');
INSERT INTO `rule_group_mapping` (`rule_id`, `group_id`) VALUES ('c30779c4-44b8-4c7b-b2ec-29ff3a96033b', '12');


INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('02971259-93f0-4cbe-921b-e9c589ca3543', '0dda84c1-794b-4977-bb66-6f12695c6c51', 'aws.rds');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('04de48af-246a-43eb-8e14-841fbe1f15a9', 'fa5e89e3-417d-4296-9d17-ca51ed914be5', 'aws.ec2');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('1141ed89-25e0-48bd-aaf6-97cc5acb1dbd', 'bd1a0479-ef54-4208-a520-50caf6acfe87', 'aws.ec2');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('38a515ae-1b16-4bd2-a2d6-4702019cbd00', '35b5c651-5bd6-44b8-85ee-ae6adfa42dc3', 'aws.network-addr');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('441f8d7b-bf9a-4382-90fb-d5112e92fd0f', 'd0f3f4b0-000a-4407-85ee-ed4a2f9dac44', 'aws.s3');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('585aee63-8f15-4223-b8bb-9e3aa0536ccd', 'befc89d7-1811-404a-9226-f8ecc22820e0', 'aws.ebs');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('73d2ce15-9807-40c9-9041-ee676a659957', 'b57cbdba-b4d7-4da7-84db-25b9f2d5324b', 'aws.ec2');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('83d17018-bec2-4ac5-adb1-3e2f49a8a6dc', 'b1491f69-f3b8-40ae-9659-4242dbc30a0b', 'aws.rds');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('92939df9-ff43-498f-ad2d-11203266d7bd', 'a90a1ba1-b392-4bf2-af31-20ecbefe5811', 'aws.ebs');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('adda0759-00ee-4448-836d-96d4d495fa16', '07eb95ef-6d78-4b9a-8555-a42b6a16de99', 'aws.elb');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('ce6f382c-9836-4afa-9bcf-e9b64931b5e0', '5c47228c-7fe1-484b-a5b6-7c1968074f69', 'aws.ec2');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('d5a21004-1674-4bec-9e16-7d877249b453', 'c30779c4-44b8-4c7b-b2ec-29ff3a96033b', 'aws.s3');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('d70cdd13-9c90-47ca-977f-de95af872d01', '43a1556b-5417-4efb-88fc-33e8eeb68f71', 'aws.security-group');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('dc3f8693-c389-490a-847e-fedffefa445f', '0be7f5d4-766c-4b2b-910d-bec0f3aac977', 'aws.elb');
INSERT INTO `rule_type` (`id`, `rule_id`, `resource_type`) VALUES ('eae5f805-9e45-44a6-a1dd-f3255da685ca', 'a6c513a8-8e18-4341-94b7-b6588fdcd1f4', 'aws.rds');
