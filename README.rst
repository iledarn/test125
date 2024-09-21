.. code-block:: bash

   git clone https://github.com/iledarn/test125.git
   cd test125
   nix profile install

   gitaggregate -c repos.yaml

   python autoaggregate.py

   gitaggregate -c auto_repos.yaml

   cd ~

   git clone <your_private_doodba_based_repo>

   ln -s /home/ubuntu/<private_doodba_repo_name>/odoo/custom/src/private/ test125/

   cd test125

   mkdir -p auto/addons

   python 40-addons-link.py

   cd ~

   ./test125/odoo/odoo-bin -s

   mv .odoorc odoo.conf
