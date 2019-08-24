<template>
  <v-app>
    <v-navigation-drawer
      permanent
      app
      width="200"
    >
      <v-toolbar flat>
        <v-list>
          <v-list-tile>
            <v-list-tile-content>
              <v-list-tile-title
                class="title text-xs-center"
              >
                Inventoria
              </v-list-tile-title>

              <v-list-tile-sub-title
                class="text-xs-center caption"
              >
                {{ subtitle }}
              </v-list-tile-sub-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
      </v-toolbar>

      <v-divider />

      <v-list dense class="pt-0">
        <v-list-tile
          v-for="(item, i) in navItems"
          :to="item.to"
          :key="i"
          @click=""
        >
          <v-list-tile-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-tile-action>

          <v-list-tile-content>
            <v-list-tile-title>{{ item.label }}</v-list-tile-title>
          </v-list-tile-content>
        </v-list-tile>
      </v-list>

      <template
        v-if="$currentUser.isSuperadmin"
      >
        <v-divider />

        <v-subheader>
          Superadmin
        </v-subheader>

        <v-list dense class="pt-0">
          <v-list-tile
            v-for="(item, i) in superAdminNavItems"
            :to="item.to"
            :key="i"
            @click=""
          >
            <v-list-tile-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-tile-action>

            <v-list-tile-content>
              <v-list-tile-title>{{ item.label }}</v-list-tile-title>
            </v-list-tile-content>
          </v-list-tile>
        </v-list>
      </template>
    </v-navigation-drawer>

    <v-content>
      <router-view />
    </v-content>

    <snackbar />
    <base-dialog />

  </v-app>
</template>

<script>
  import { mapGetters } from 'vuex';
  import Snackbar from '@/components/Snackbar';
  import BaseDialog from '@/components/dialogs/BaseDialog';

  export default {
    components: {
      Snackbar,
      BaseDialog,
    },

    computed: {
      ...mapGetters({
        isDevEnv: 'utils/isDevEnv',
        isDemoEnv: 'utils/isDemoEnv',
        isProductionEnv: 'utils/isProductionEnv',
      }),


      subtitle() {
        if (this.isDevEnv) {
          return 'Local';
        }

        if (this.isDemoEnv) {
          return 'Demo';
        }

        return 'Dentsply Sirona';
      },
    },

    data: () => ({
      navItems: [
        {
          label: 'Varastot',
          to: '/admin/varastot',
          icon: 'web',
        },
        {
          label: 'Kaikki artikkelit',
          to: '/admin/artikkelit',
          icon: 'list',
        },
        {
          label: 'Käyttäjä',
          to: '/admin/kayttaja',
          icon: 'face',
        },
      ],

      superAdminNavItems: [
        {
          label: 'Käyttäjät',
          to: '/superadmin/kayttajat',
          icon: 'group',
        },
        {
          label: 'Datamatriisi',
          to: '/superadmin/datamatriisi-generaattori',
          icon: 'code',
        },
      ],
    }),
  };
</script>
