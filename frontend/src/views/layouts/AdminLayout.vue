<template>
  <v-app>
    <v-navigation-drawer
      permanent
      app
    >
      <v-toolbar flat>
        <v-list>
          <v-list-tile>
            <v-list-tile-title
              class="title text-xs-center"
            >
              <v-icon>
                favorite_border
              </v-icon>
            </v-list-tile-title>
          </v-list-tile>
        </v-list>
      </v-toolbar>

      <v-divider></v-divider>

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
    </v-navigation-drawer>

    <v-content>
      <router-view />
    </v-content>

    <snackbar />
    <base-dialog />

  </v-app>
</template>

<script>
  import Snackbar from '@/components/Snackbar';
  import BaseDialog from '@/components/dialogs/BaseDialog';

  export default {
    components: {
      Snackbar,
      BaseDialog,
    },

    data: () => ({
      navItems: [
        {
          label: 'Varastot',
          to: '/admin/varastot',
          color: 'teal',
          icon: 'group',
        },
        {
          label: 'Käyttäjä',
          to: '/admin/kayttaja',
          color: 'teal',
          icon: 'face',
        },
      ],
    }),
  };
</script>
