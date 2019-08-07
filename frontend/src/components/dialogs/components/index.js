const components = {};
const context = require.context('@/components/dialogs/components', true, /\.vue$/);

context.keys().forEach((fileName) => {
  const component = `${fileName.replace(/(\.\/|\.vue)/g, '')}`;

  components[component] = context(fileName).default;
});

export default components;
